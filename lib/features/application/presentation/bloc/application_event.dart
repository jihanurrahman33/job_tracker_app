import 'package:equatable/equatable.dart';
import '../../domain/entities/application_entity.dart';

abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();

  @override
  List<Object?> get props => [];
}

class LoadApplicationsEvent extends ApplicationEvent {
  final bool refresh;
  const LoadApplicationsEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreApplicationsEvent extends ApplicationEvent {
  const LoadMoreApplicationsEvent();
}

class FilterStatusChangedEvent extends ApplicationEvent {
  final String? status;
  const FilterStatusChangedEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchQueryChangedEvent extends ApplicationEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SortOptionChangedEvent extends ApplicationEvent {
  final String sort;
  const SortOptionChangedEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class DeleteApplicationItemEvent extends ApplicationEvent {
  final String id;
  const DeleteApplicationItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ApplicationUpdatedInListEvent extends ApplicationEvent {
  final ApplicationEntity application;
  const ApplicationUpdatedInListEvent(this.application);

  @override
  List<Object?> get props => [application];
}
