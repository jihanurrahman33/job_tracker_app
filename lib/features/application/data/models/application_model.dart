import '../../domain/entities/application_entity.dart';

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.id,
    required super.userId,
    required super.company,
    required super.position,
    super.location,
    super.jobUrl,
    super.salaryMin,
    super.salaryMax,
    super.salaryCurrency = 'USD',
    required super.status,
    super.appliedAt,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      company: json['company'] as String? ?? '',
      position: json['position'] as String? ?? '',
      location: json['location'] as String?,
      jobUrl: json['job_url'] as String?,
      salaryMin: (json['salary_min'] as num?)?.toInt(),
      salaryMax: (json['salary_max'] as num?)?.toInt(),
      salaryCurrency: json['salary_currency'] as String? ?? 'USD',
      status: json['status'] as String? ?? 'APPLIED',
      appliedAt: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'] as String)
          : null,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'company': company,
      'position': position,
      'status': status,
      'salary_currency': salaryCurrency,
    };

    if (location != null) map['location'] = location;
    if (jobUrl != null) map['job_url'] = jobUrl;
    if (salaryMin != null) map['salary_min'] = salaryMin;
    if (salaryMax != null) map['salary_max'] = salaryMax;
    if (appliedAt != null) {
      map['applied_at'] = appliedAt!.toUtc().toIso8601String();
    }
    if (notes != null) map['notes'] = notes;

    return map;
  }
}
