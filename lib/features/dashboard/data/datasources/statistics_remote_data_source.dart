import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/networking/api_client.dart';
import '../models/statistics_model.dart';

abstract class StatisticsRemoteDataSource {
  Future<StatisticsModel> getStatistics();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final ApiClient apiClient;

  StatisticsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<StatisticsModel> getStatistics() async {
    final response = await apiClient.get(ApiEndpoints.statistics);

    if (response is Map<String, dynamic>) {
      final json = (response.containsKey('data') && response['data'] is Map<String, dynamic>)
          ? response['data'] as Map<String, dynamic>
          : response;
      return StatisticsModel.fromJson(json);
    }

    throw const ServerException(
        message: 'Failed to fetch application statistics.');
  }
}
