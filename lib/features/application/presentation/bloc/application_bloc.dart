import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_application_usecase.dart';
import '../../domain/usecases/get_applications_usecase.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final GetApplicationsUseCase getApplicationsUseCase;
  final DeleteApplicationUseCase deleteApplicationUseCase;

  ApplicationBloc({
    required this.getApplicationsUseCase,
    required this.deleteApplicationUseCase,
  }) : super(const ApplicationState()) {
    on<LoadApplicationsEvent>(_onLoadApplications);
    on<LoadMoreApplicationsEvent>(_onLoadMoreApplications);
    on<FilterStatusChangedEvent>(_onFilterStatusChanged);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SortOptionChangedEvent>(_onSortOptionChanged);
    on<DeleteApplicationItemEvent>(_onDeleteApplicationItem);
  }

  Future<void> _onLoadApplications(
    LoadApplicationsEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    if (event.refresh || state.applications.isEmpty) {
      emit(state.copyWith(
        status: ApplicationListStatus.loading,
        errorMessage: null,
      ));
    }

    final result = await getApplicationsUseCase(
      GetApplicationsParams(
        page: 1,
        limit: 20,
        status: state.selectedStatus,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        sort: state.sortBy,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ApplicationListStatus.error,
        errorMessage: failure.message,
      )),
      (data) {
        final (apps, pagination) = data;
        emit(state.copyWith(
          status: ApplicationListStatus.loaded,
          applications: apps,
          pagination: pagination,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onLoadMoreApplications(
    LoadMoreApplicationsEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    if (!state.hasMore || state.status == ApplicationListStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: ApplicationListStatus.loadingMore));

    final nextPage = (state.pagination?.page ?? 1) + 1;
    final result = await getApplicationsUseCase(
      GetApplicationsParams(
        page: nextPage,
        limit: 20,
        status: state.selectedStatus,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        sort: state.sortBy,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ApplicationListStatus.loaded,
        errorMessage: failure.message,
      )),
      (data) {
        final (newApps, pagination) = data;
        emit(state.copyWith(
          status: ApplicationListStatus.loaded,
          applications: [...state.applications, ...newApps],
          pagination: pagination,
        ));
      },
    );
  }

  void _onFilterStatusChanged(
    FilterStatusChangedEvent event,
    Emitter<ApplicationState> emit,
  ) {
    if (event.status == null) {
      emit(state.copyWith(clearStatus: true));
    } else {
      emit(state.copyWith(selectedStatus: event.status));
    }
    add(const LoadApplicationsEvent(refresh: true));
  }

  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<ApplicationState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    add(const LoadApplicationsEvent(refresh: true));
  }

  void _onSortOptionChanged(
    SortOptionChangedEvent event,
    Emitter<ApplicationState> emit,
  ) {
    emit(state.copyWith(sortBy: event.sort));
    add(const LoadApplicationsEvent(refresh: true));
  }

  Future<void> _onDeleteApplicationItem(
    DeleteApplicationItemEvent event,
    Emitter<ApplicationState> emit,
  ) async {
    final prevList = state.applications;
    final updatedList =
        state.applications.where((a) => a.id != event.id).toList();
    emit(state.copyWith(applications: updatedList));

    final result = await deleteApplicationUseCase(
      DeleteApplicationParams(id: event.id),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          applications: prevList,
          errorMessage: failure.message,
        ));
      },
      (_) {},
    );
  }
}
