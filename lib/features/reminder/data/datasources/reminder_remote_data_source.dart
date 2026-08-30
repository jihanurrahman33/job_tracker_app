import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/networking/api_client.dart';
import '../models/reminder_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderModel>> getReminders();

  Future<ReminderModel> createReminder({
    String? applicationId,
    required String title,
    String? description,
    required DateTime remindAt,
  });

  Future<ReminderModel> updateReminder({
    required String id,
    String? title,
    String? description,
    DateTime? remindAt,
    bool? completed,
  });

  Future<void> deleteReminder(String id);
}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final ApiClient apiClient;

  ReminderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReminderModel>> getReminders() async {
    final response = await apiClient.get(ApiEndpoints.reminders);

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final list = response['data'] as List<dynamic>?;
      return list
              ?.map((item) =>
                  ReminderModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [];
    } else if (response is List<dynamic>) {
      return response
          .map((item) => ReminderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<ReminderModel> createReminder({
    String? applicationId,
    required String title,
    String? description,
    required DateTime remindAt,
  }) async {
    final body = <String, dynamic>{
      'title': title.trim(),
      'remind_at': remindAt.toUtc().toIso8601String(),
    };

    if (applicationId != null && applicationId.isNotEmpty) {
      body['application_id'] = applicationId;
    }
    if (description != null && description.trim().isNotEmpty) {
      body['description'] = description.trim();
    }

    final response = await apiClient.post(
      ApiEndpoints.reminders,
      body: body,
    );

    if (response is Map<String, dynamic>) {
      return ReminderModel.fromJson(response);
    }

    throw const ServerException(message: 'Failed to create reminder.');
  }

  @override
  Future<ReminderModel> updateReminder({
    required String id,
    String? title,
    String? description,
    DateTime? remindAt,
    bool? completed,
  }) async {
    final body = <String, dynamic>{};

    if (title != null) body['title'] = title.trim();
    if (description != null) body['description'] = description.trim();
    if (remindAt != null)
      body['remind_at'] = remindAt.toUtc().toIso8601String();
    if (completed != null) body['completed'] = completed;

    final response = await apiClient.patch(
      ApiEndpoints.reminderById(id),
      body: body,
    );

    if (response is Map<String, dynamic>) {
      return ReminderModel.fromJson(response);
    }

    throw const ServerException(message: 'Failed to update reminder.');
  }

  @override
  Future<void> deleteReminder(String id) async {
    await apiClient.delete(ApiEndpoints.reminderById(id));
  }
}
