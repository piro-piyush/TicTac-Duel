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
  HttpService({
    required String baseUrl,
  }) : _dio = Dio(
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
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,

      ),
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
    final body = response.data;

    if (body == null) {
      throw ApiException(
        message: 'Invalid response from server.',
        statusCode: response.statusCode,
      );
    }

    final success = body['success'];

    if (success != true) {
      throw ApiException(
        message: body['message']?.toString() ?? 'Something went wrong.',
        statusCode: response.statusCode,
        errors: body['errors'],
      );
    }

    return body['data'] as T;
  }

  // ===========================================================================
  // DIO ERROR
  // ===========================================================================

  ApiException _handleDioException(DioException error) {
    final response = error.response;

    if (response?.data is Map) {
      final data = Map<String, dynamic>.from(response!.data as Map);

      return ApiException(
        message: data['message']?.toString() ?? _defaultDioMessage(error),
        statusCode: response.statusCode,
        errors: data['errors'],
      );
    }

    return ApiException(
      message: _defaultDioMessage(error),
      statusCode: response?.statusCode,
    );
  }

  // ===========================================================================
  // DEFAULT ERROR MESSAGE
  // ===========================================================================

  String _defaultDioMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out.';

      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timed out.';

      case DioExceptionType.badCertificate:
        return 'Invalid server certificate.';

      case DioExceptionType.badResponse:
        return 'Server returned an invalid response.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the server.';

      case DioExceptionType.unknown:
        return 'Something went wrong.';

      case DioExceptionType.transformTimeout:
        return 'Response transformation timed out.';
    }
  }
}
