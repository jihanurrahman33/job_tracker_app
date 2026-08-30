import 'package:equatable/equatable.dart';

class ApplicationEntity extends Equatable {
  final String id;
  final String userId;
  final String company;
  final String position;
  final String? location;
  final String? jobUrl;
  final int? salaryMin;
  final int? salaryMax;
  final String salaryCurrency;
  final String status;
  final DateTime? appliedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ApplicationEntity({
    required this.id,
    required this.userId,
    required this.company,
    required this.position,
    this.location,
    this.jobUrl,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency = 'USD',
    required this.status,
    this.appliedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedSalary {
    if (salaryMin == null && salaryMax == null) return 'Not specified';
    if (salaryMin != null && salaryMax != null) {
      return '$salaryCurrency ${(salaryMin! / 1000).toStringAsFixed(0)}k - ${(salaryMax! / 1000).toStringAsFixed(0)}k';
    }
    if (salaryMin != null) {
      return '$salaryCurrency ${(salaryMin! / 1000).toStringAsFixed(0)}k+';
    }
    return 'Up to $salaryCurrency ${(salaryMax! / 1000).toStringAsFixed(0)}k';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        company,
        position,
        location,
        jobUrl,
        salaryMin,
        salaryMax,
        salaryCurrency,
        status,
        appliedAt,
        notes,
        createdAt,
        updatedAt,
      ];
}
