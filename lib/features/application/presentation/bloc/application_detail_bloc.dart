import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_application_detail_usecase.dart';
import '../../domain/usecases/get_application_events_usecase.dart';
import '../../domain/usecases/update_application_usecase.dart';
import 'application_detail_event.dart';
import 'application_detail_state.dart';

class ApplicationDetailBloc
    extends Bloc<ApplicationDetailEvent, ApplicationDetailState> {
  final GetApplicationDetailUseCase getApplicationDetailUseCase;
  final GetApplicationEventsUseCase getApplicationEventsUseCase;
  final UpdateApplicationUseCase updateApplicationUseCase;

  ApplicationDetailBloc({
    required this.getApplicationDetailUseCase,
    required this.getApplicationEventsUseCase,
    required this.updateApplicationUseCase,
  }) : super(const ApplicationDetailState()) {
    on<LoadApplicationDetailEvent>(_onLoadApplicationDetail);
    on<ChangeApplicationStatusEvent>(_onChangeApplicationStatus);
  }

  Future<void> _onLoadApplicationDetail(
    LoadApplicationDetailEvent event,
    Emitter<ApplicationDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: ApplicationDetailStatus.loading,
      errorMessage: null,
    ));

    final appResult = await getApplicationDetailUseCase(
      GetApplicationDetailParams(id: event.id),
    );

    await appResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: ApplicationDetailStatus.error,
          errorMessage: failure.message,
        ));
      },
      (app) async {
        final eventsResult = await getApplicationEventsUseCase(
          GetApplicationEventsParams(id: event.id),
        );

        final events = eventsResult.fold((_) => state.events, (ev) => ev);

        emit(state.copyWith(
          status: ApplicationDetailStatus.loaded,
          application: app,
          events: events,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onChangeApplicationStatus(
    ChangeApplicationStatusEvent event,
    Emitter<ApplicationDetailState> emit,
  ) async {
    emit(state.copyWith(status: ApplicationDetailStatus.updating));

    final result = await updateApplicationUseCase(
      UpdateApplicationParams(
        id: event.id,
        status: event.newStatus,
        notes: event.notes,
      ),
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(
          status: ApplicationDetailStatus.error,
          errorMessage: failure.message,
        ));
      },
      (updatedApp) async {
        final eventsResult = await getApplicationEventsUseCase(
          GetApplicationEventsParams(id: event.id),
        );

        final events = eventsResult.fold((_) => state.events, (ev) => ev);

        emit(state.copyWith(
          status: ApplicationDetailStatus.loaded,
          application: updatedApp,
          events: events,
        ));
      },
    );
  }
}
