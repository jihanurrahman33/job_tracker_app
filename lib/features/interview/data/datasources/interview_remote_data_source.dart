import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/networking/api_client.dart';
import '../models/interview_model.dart';

abstract class InterviewRemoteDataSource {
  Future<List<InterviewModel>> getInterviewsByApplication(String applicationId);
  Future<InterviewModel> getInterviewDetail(String id);
  Future<InterviewModel> createInterview({
    required String applicationId,
    required String type,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  });
  Future<InterviewModel> updateInterview({
    required String id,
    String? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  });
  Future<void> deleteInterview(String id);
}

class InterviewRemoteDataSourceImpl implements InterviewRemoteDataSource {
  final ApiClient apiClient;

  InterviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<InterviewModel>> getInterviewsByApplication(
      String applicationId) async {
    final response = await apiClient.get(
      ApiEndpoints.applicationInterviews(applicationId),
    );

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final list = response['data'] as List<dynamic>?;
      return list
              ?.map((item) =>
                  InterviewModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [];
    } else if (response is List<dynamic>) {
      return response
          .map((item) => InterviewModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<InterviewModel> getInterviewDetail(String id) async {
    final response = await apiClient.get(ApiEndpoints.interviewById(id));

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return InterviewModel.fromJson(json);
    }

    throw const ServerException(message: 'Failed to fetch interview details.');
  }

  @override
  Future<InterviewModel> createInterview({
    required String applicationId,
    required String type,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'type': type,
      'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      'duration_minutes': durationMinutes,
    };

    if (location != null && location.trim().isNotEmpty) {
      body['location'] = location.trim();
    }
    if (meetingUrl != null && meetingUrl.trim().isNotEmpty) {
      body['meeting_url'] = meetingUrl.trim();
    }
    if (notes != null && notes.trim().isNotEmpty) {
      body['notes'] = notes.trim();
    }

    final response = await apiClient.post(
      ApiEndpoints.applicationInterviews(applicationId),
      body: body,
    );

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return InterviewModel.fromJson(json);
    }

    throw const ServerException(message: 'Failed to create interview.');
  }

  @override
  Future<InterviewModel> updateInterview({
    required String id,
    String? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? location,
    String? meetingUrl,
    String? notes,
  }) async {
    final body = <String, dynamic>{};

    if (type != null) body['type'] = type;
    if (scheduledAt != null) {
      body['scheduled_at'] = scheduledAt.toUtc().toIso8601String();
    }
    if (durationMinutes != null) body['duration_minutes'] = durationMinutes;
    if (location != null) body['location'] = location.trim();
    if (meetingUrl != null) body['meeting_url'] = meetingUrl.trim();
    if (notes != null) body['notes'] = notes.trim();

    final response = await apiClient.patch(
      ApiEndpoints.interviewById(id),
      body: body,
    );

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return InterviewModel.fromJson(json);
    }

    throw const ServerException(message: 'Failed to update interview.');
  }

  @override
  Future<void> deleteInterview(String id) async {
    await apiClient.delete(ApiEndpoints.interviewById(id));
  }
}
