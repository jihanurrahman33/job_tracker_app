import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_statistics_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetStatisticsUseCase getStatisticsUseCase;

  DashboardBloc({required this.getStatisticsUseCase})
      : super(const DashboardState()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.refresh || state.statistics == null) {
      emit(state.copyWith(status: DashboardStatus.loading, errorMessage: null));
    }

    final result = await getStatisticsUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: failure.message,
      )),
      (stats) => emit(state.copyWith(
        status: DashboardStatus.loaded,
        statistics: stats,
        errorMessage: null,
      )),
    );
  }
}
