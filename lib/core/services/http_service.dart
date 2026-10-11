import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.errors});

  final String message;
  final int? statusCode;
  final dynamic errors;

  @override
  String toString() => message;
}

class HttpService {
  HttpService({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  final Dio _dio;

  // ===========================================================================
  // GET
  // ===========================================================================

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      return _parseResponse<T>(response);
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  // ===========================================================================
  // POST
  // ===========================================================================

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _parseResponse<T>(response);
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  // ===========================================================================
  // PUT
  // ===========================================================================

  Future<T> put<T>(String path, {Object? data}) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(path, data: data);

      return _parseResponse<T>(response);
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  Future<T> delete<T>(String path, {Object? data}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        data: data,
      );

      return _parseResponse<T>(response);
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  // ===========================================================================
  // RESPONSE
  // ===========================================================================

  T _parseResponse<T>(Response<Map<String, dynamic>> response) {
    final statusCode = response.statusCode;

    // -------------------------------------------------------------------------
    // 204 No Content
    // -------------------------------------------------------------------------

    if (statusCode == 204) {
      return null as T;
    }

    final body = response.data;

    if (body == null) {
      throw ApiException(
        message: 'Invalid response from server.',
        statusCode: statusCode,
      );
    }

    final success = body['success'];

    if (success != true) {
      throw ApiException(
        message:
            body['message']?.toString() ?? _messageForStatusCode(statusCode),
        statusCode: statusCode,
        errors: body['errors'],
      );
    }

    final data = body['data'];

    if (data == null) {
      return null as T;
    }

    try {
      return data as T;
    } on TypeError {
      throw ApiException(
        message: 'Invalid response data from server.',
        statusCode: statusCode,
        errors: data,
      );
    }
  }

  // ===========================================================================
  // DIO ERROR
  // ===========================================================================

  ApiException _handleDioException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    final body = _extractResponseBody(response);

    if (body != null) {
      return ApiException(
        message:
            body['message']?.toString() ?? _messageForStatusCode(statusCode),
        statusCode: statusCode,
        errors: body['errors'],
      );
    }

    return ApiException(
      message: _messageForDioException(error),
      statusCode: statusCode,
    );
  }

  // ===========================================================================
  // RESPONSE BODY
  // ===========================================================================

  Map<String, dynamic>? _extractResponseBody(Response<dynamic>? response) {
    final data = response?.data;

    if (data is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(data);
  }

  // ===========================================================================
  // DIO ERROR MESSAGE
  // ===========================================================================

  String _messageForDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timed out. Please try again.';

      case DioExceptionType.badCertificate:
        return 'Unable to verify the server certificate.';

      case DioExceptionType.badResponse:
        return _messageForStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the server. Please check your connection.';

      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';

      case DioExceptionType.transformTimeout:
        return 'Server response took too long to process.';
    }
  }

  // ===========================================================================
  // HTTP STATUS MESSAGE
  // ===========================================================================

  String _messageForStatusCode(int? statusCode) {
    switch (statusCode) {
      // -----------------------------------------------------------------------
      // Client Errors
      // -----------------------------------------------------------------------

      case 400:
        return 'Invalid request.';

      case 401:
        return 'You are not authorized.';

      case 403:
        return 'You do not have permission to perform this action.';

      case 404:
        return 'The requested resource was not found.';

      case 409:
        return 'This action conflicts with the current state.';

      case 422:
        return 'The submitted data is invalid.';

      case 429:
        return 'Too many requests. Please try again later.';

      // -----------------------------------------------------------------------
      // Server Errors
      // -----------------------------------------------------------------------

      case 500:
        return 'Something went wrong on the server.';

      case 502:
        return 'The server is temporarily unavailable.';

      case 503:
        return 'The server is currently unavailable.';

      case 504:
        return 'The server took too long to respond.';

      // -----------------------------------------------------------------------
      // Unknown
      // -----------------------------------------------------------------------

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
