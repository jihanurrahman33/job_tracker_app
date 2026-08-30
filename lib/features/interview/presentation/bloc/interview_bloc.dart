import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_interview_usecase.dart';
import '../../domain/usecases/get_interviews_by_app_usecase.dart';
import 'interview_event.dart';
import 'interview_state.dart';

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final GetInterviewsByAppUseCase getInterviewsByAppUseCase;
  final DeleteInterviewUseCase deleteInterviewUseCase;

  InterviewBloc({
    required this.getInterviewsByAppUseCase,
    required this.deleteInterviewUseCase,
  }) : super(const InterviewState()) {
    on<LoadInterviewsForAppEvent>(_onLoadInterviews);
    on<DeleteInterviewItemEvent>(_onDeleteInterviewItem);
  }

  Future<void> _onLoadInterviews(
    LoadInterviewsForAppEvent event,
    Emitter<InterviewState> emit,
  ) async {
    emit(state.copyWith(
        status: InterviewListStatus.loading, errorMessage: null));

    final result = await getInterviewsByAppUseCase(
      GetInterviewsByAppParams(applicationId: event.applicationId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: InterviewListStatus.error,
        errorMessage: failure.message,
      )),
      (interviews) => emit(state.copyWith(
        status: InterviewListStatus.loaded,
        interviews: interviews,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onDeleteInterviewItem(
    DeleteInterviewItemEvent event,
    Emitter<InterviewState> emit,
  ) async {
    final prevList = state.interviews;
    final updatedList =
        state.interviews.where((i) => i.id != event.id).toList();
    emit(state.copyWith(interviews: updatedList));

    final result =
        await deleteInterviewUseCase(DeleteInterviewParams(id: event.id));

    result.fold(
      (failure) {
        emit(state.copyWith(
          interviews: prevList,
          errorMessage: failure.message,
        ));
      },
      (_) {},
    );
  }
}
