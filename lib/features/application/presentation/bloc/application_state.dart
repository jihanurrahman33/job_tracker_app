import 'package:equatable/equatable.dart';
import '../../../../core/networking/api_response.dart';
import '../../domain/entities/application_entity.dart';

enum ApplicationListStatus { initial, loading, loaded, loadingMore, error }

class ApplicationState extends Equatable {
  final ApplicationListStatus status;
  final List<ApplicationEntity> applications;
  final PaginationMeta? pagination;
  final String? selectedStatus;
  final String searchQuery;
  final String sortBy;
  final String? errorMessage;

  const ApplicationState({
    this.status = ApplicationListStatus.initial,
    this.applications = const [],
    this.pagination,
    this.selectedStatus,
    this.searchQuery = '',
    this.sortBy = '-applied_at',
    this.errorMessage,
  });

  bool get hasMore => pagination?.hasMore ?? false;

  ApplicationState copyWith({
    ApplicationListStatus? status,
    List<ApplicationEntity>? applications,
    PaginationMeta? pagination,
    String? selectedStatus,
    bool clearStatus = false,
    String? searchQuery,
    String? sortBy,
    String? errorMessage,
  }) {
    return ApplicationState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      pagination: pagination ?? this.pagination,
      selectedStatus:
          clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        applications,
        pagination,
        selectedStatus,
        searchQuery,
        sortBy,
        errorMessage,
      ];
}
