import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {
  final bool refresh;
  const LoadDashboardDataEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}
