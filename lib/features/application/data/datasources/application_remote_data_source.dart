import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/networking/api_client.dart';
import '../../../../core/networking/api_response.dart';
import '../models/application_event_model.dart';
import '../models/application_model.dart';

abstract class ApplicationRemoteDataSource {
  Future<(List<ApplicationModel>, PaginationMeta)> getApplications({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
    String? sort,
  });

  Future<ApplicationModel> getApplicationDetail(String id);

  Future<ApplicationModel> createApplication({
    required String company,
    required String position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    required String status,
    DateTime? appliedAt,
    String? notes,
  });

  Future<ApplicationModel> updateApplication({
    required String id,
    String? company,
    String? position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    String? status,
    DateTime? appliedAt,
    String? notes,
  });

  Future<void> deleteApplication(String id);

  Future<List<ApplicationEventModel>> getApplicationEvents(String id);
}

class ApplicationRemoteDataSourceImpl implements ApplicationRemoteDataSource {
  final ApiClient apiClient;

  ApplicationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<(List<ApplicationModel>, PaginationMeta)> getApplications({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
    String? sort,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await apiClient.get(
      ApiEndpoints.applications,
      queryParameters: queryParams,
    );

    if (response is Map<String, dynamic>) {
      final dataList = (response['data'] is List<dynamic>)
          ? response['data'] as List<dynamic>
          : (response['applications'] is List<dynamic>
              ? response['applications'] as List<dynamic>
              : <dynamic>[]);

      final applications = dataList
          .map((json) => ApplicationModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final metaJson = response['meta'] as Map<String, dynamic>? ??
          {
            'page': page,
            'limit': limit,
            'total': applications.length,
            'total_pages': (applications.length / limit).ceil(),
          };

      final meta = PaginationMeta.fromJson(metaJson);
      return (applications, meta);
    }

    throw const ServerException(message: 'Failed to fetch applications.');
  }

  @override
  Future<ApplicationModel> getApplicationDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.applicationById(id));

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return ApplicationModel.fromJson(json);
    }

    throw const ServerException(
        message: 'Failed to fetch application details.');
  }

  @override
  Future<ApplicationModel> createApplication({
    required String company,
    required String position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    required String status,
    DateTime? appliedAt,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'company': company.trim(),
      'position': position.trim(),
      'status': status,
      'salary_currency': salaryCurrency ?? 'USD',
    };

    if (location != null && location.trim().isNotEmpty) {
      body['location'] = location.trim();
    }
    if (jobUrl != null && jobUrl.trim().isNotEmpty) {
      body['job_url'] = jobUrl.trim();
    }
    if (salaryMin != null) body['salary_min'] = salaryMin;
    if (salaryMax != null) body['salary_max'] = salaryMax;
    if (appliedAt != null) {
      body['applied_at'] = appliedAt.toUtc().toIso8601String();
    }
    if (notes != null && notes.trim().isNotEmpty) {
      body['notes'] = notes.trim();
    }

    final response = await apiClient.post(
      ApiEndpoints.applications,
      body: body,
    );

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return ApplicationModel.fromJson(json);
    }

    throw const ServerException(message: 'Failed to create application.');
  }

  @override
  Future<ApplicationModel> updateApplication({
    required String id,
    String? company,
    String? position,
    String? location,
    String? jobUrl,
    int? salaryMin,
    int? salaryMax,
    String? salaryCurrency,
    String? status,
    DateTime? appliedAt,
    String? notes,
  }) async {
    final body = <String, dynamic>{};

    if (company != null) body['company'] = company.trim();
    if (position != null) body['position'] = position.trim();
    if (location != null) body['location'] = location.trim();
    if (jobUrl != null) body['job_url'] = jobUrl.trim();
    if (salaryMin != null) body['salary_min'] = salaryMin;
    if (salaryMax != null) body['salary_max'] = salaryMax;
    if (salaryCurrency != null) body['salary_currency'] = salaryCurrency;
    if (status != null) body['status'] = status;
    if (appliedAt != null) {
      body['applied_at'] = appliedAt.toUtc().toIso8601String();
    }
    if (notes != null) body['notes'] = notes.trim();

    final response = await apiClient.patch(
      ApiEndpoints.applicationById(id),
      body: body,
    );

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return ApplicationModel.fromJson(json);
    }

    throw const ServerException(message: 'Failed to update application.');
  }

  @override
  Future<void> deleteApplication(String id) async {
    await apiClient.delete(ApiEndpoints.applicationById(id));
  }

  @override
  Future<List<ApplicationEventModel>> getApplicationEvents(String id) async {
    final response = await apiClient.get(ApiEndpoints.applicationEvents(id));

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final list = response['data'] as List<dynamic>?;
      return list
              ?.map((item) =>
                  ApplicationEventModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [];
    } else if (response is List<dynamic>) {
      return response
          .map((item) =>
              ApplicationEventModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
