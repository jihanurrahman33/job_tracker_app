import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../error/exceptions.dart';

class ApiClient {
  final http.Client _client;
  String _baseUrl;
  String? _authToken;

  ApiClient({
    required http.Client client,
    String baseUrl = ApiEndpoints.defaultBaseUrl,
  })  : _client = client,
        _baseUrl = baseUrl;

  String get baseUrl => _baseUrl;
  String? get authToken => _authToken;

  void setBaseUrl(String url) {
    if (url.endsWith('/')) {
      _baseUrl = url.substring(0, url.length - 1);
    } else {
      _baseUrl = url;
    }
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _buildHeaders({Map<String, String>? extraHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$_baseUrl$cleanPath';

    if (queryParameters == null || queryParameters.isEmpty) {
      return Uri.parse(fullUrl);
    }

    final sanitizedParams = <String, String>{};
    queryParameters.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        sanitizedParams[key] = value.toString();
      }
    });

    return Uri.parse(fullUrl).replace(queryParameters: sanitizedParams);
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .get(uri, headers: _buildHeaders(extraHeaders: headers))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NetworkException();
    } on TimeoutException catch (_) {
      throw const NetworkException(
        message: 'Request timed out. Please check your connection.',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NetworkException();
    } on TimeoutException catch (_) {
      throw const NetworkException(
        message: 'Request timed out. Please check your connection.',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message);
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NetworkException();
    } on TimeoutException catch (_) {
      throw const NetworkException(
        message: 'Request timed out. Please check your connection.',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message);
    }
  }

  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .patch(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NetworkException();
    } on TimeoutException catch (_) {
      throw const NetworkException(
        message: 'Request timed out. Please check your connection.',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message);
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .delete(
            uri,
            headers: _buildHeaders(extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NetworkException();
    } on TimeoutException catch (_) {
      throw const NetworkException(
        message: 'Request timed out. Please check your connection.',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final bodyString = response.body.trim();

    dynamic decodedBody;
    if (bodyString.isNotEmpty) {
      try {
        decodedBody = jsonDecode(bodyString);
      } catch (_) {
        decodedBody = bodyString;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedBody;
    }

    String errorMessage = 'Request failed with status $statusCode';
    dynamic details;

    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody.containsKey('error')) {
        final errorObj = decodedBody['error'];
        if (errorObj is Map<String, dynamic>) {
          errorMessage = errorObj['message']?.toString() ?? errorMessage;
          details = errorObj['details'];
        } else {
          errorMessage = errorObj.toString();
        }
      } else if (decodedBody.containsKey('message')) {
        errorMessage = decodedBody['message'].toString();
      }
    }

    if (statusCode == 401) {
      throw AuthException(message: errorMessage, statusCode: 401);
    }

    throw ServerException(
      message: errorMessage,
      statusCode: statusCode,
      details: details,
    );
  }
}
