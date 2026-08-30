import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/usecases/delete_reminder_usecase.dart';
import '../../domain/usecases/get_reminders_usecase.dart';
import '../../domain/usecases/update_reminder_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final GetRemindersUseCase getRemindersUseCase;
  final UpdateReminderUseCase updateReminderUseCase;
  final DeleteReminderUseCase deleteReminderUseCase;

  ReminderBloc({
    required this.getRemindersUseCase,
    required this.updateReminderUseCase,
    required this.deleteReminderUseCase,
  }) : super(const ReminderState()) {
    on<LoadRemindersEvent>(_onLoadReminders);
    on<ToggleReminderStatusEvent>(_onToggleReminderStatus);
    on<DeleteReminderEvent>(_onDeleteReminder);
  }

  Future<void> _onLoadReminders(
    LoadRemindersEvent event,
    Emitter<ReminderState> emit,
  ) async {
    if (event.refresh || state.reminders.isEmpty) {
      emit(state.copyWith(status: ReminderStatus.loading, errorMessage: null));
    }

    final result = await getRemindersUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: ReminderStatus.error,
        errorMessage: failure.message,
      )),
      (reminders) {
        reminders.sort((a, b) {
          if (a.completed != b.completed) {
            return a.completed ? 1 : -1;
          }
          return a.remindAt.compareTo(b.remindAt);
        });

        emit(state.copyWith(
          status: ReminderStatus.loaded,
          reminders: reminders,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onToggleReminderStatus(
    ToggleReminderStatusEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final updatedList = state.reminders.map((r) {
      if (r.id == event.id) {
        return ReminderEntity(
          id: r.id,
          userId: r.userId,
          applicationId: r.applicationId,
          title: r.title,
          description: r.description,
          remindAt: r.remindAt,
          completed: event.completed,
          createdAt: r.createdAt,
        );
      }
      return r;
    }).toList();

    emit(state.copyWith(reminders: updatedList));

    final result = await updateReminderUseCase(
      UpdateReminderParams(id: event.id, completed: event.completed),
    );

    result.fold(
      (failure) {
        add(const LoadRemindersEvent(refresh: true));
      },
      (updatedReminder) {
        final list = List<ReminderEntity>.from(state.reminders);
        list.sort((a, b) {
          if (a.completed != b.completed) return a.completed ? 1 : -1;
          return a.remindAt.compareTo(b.remindAt);
        });
        emit(state.copyWith(reminders: list));
      },
    );
  }

  Future<void> _onDeleteReminder(
    DeleteReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    final prev = state.reminders;
    final updated = state.reminders.where((r) => r.id != event.id).toList();
    emit(state.copyWith(reminders: updated));

    final result = await deleteReminderUseCase(DeleteReminderParams(id: event.id));

    result.fold(
      (failure) {
        emit(state.copyWith(reminders: prev, errorMessage: failure.message));
      },
      (_) {},
    );
  }
}
