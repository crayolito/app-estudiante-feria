import 'package:dio/dio.dart';

class BackendServiceResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  BackendServiceResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

class BackendService {
  // READ : CAMBIAR AQUI MAÑANA PARA EL USO DE LA IP DEL SERVIDOR
  static const String _baseUrl = 'http://192.168.1.101:3000/api';
  late final Dio _dio;

  // Singleton pattern
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;

  BackendService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'insomnia/10.1.1',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Agregar interceptors para logging y manejo de errores
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('🔴 Error: ${error.message}');
        return handler.next(error);
      },
      onRequest: (request, handler) {
        print('📡 Request: ${request.method} ${request.uri}');
        return handler.next(request);
      },
      onResponse: (response, handler) {
        print('✅ Response: ${response.statusCode}');
        return handler.next(response);
      },
    ));
  }

  Future<BackendServiceResponse> solveHomework(String base64Image) async {
    try {
      final response = await _dio.post(
        '/gpt/solve-homework',
        data: {
          'imageBase64': base64Image,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BackendServiceResponse(
          success: true,
          message: 'Imagen procesada exitosamente',
          data: response.data,
        );
      }

      return BackendServiceResponse(
        success: false,
        message: _getErrorMessage(response),
      );
    } on DioException catch (e) {
      return BackendServiceResponse(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return BackendServiceResponse(
        success: false,
        message: 'Error inesperado: $e',
      );
    }
  }

  Future<BackendServiceResponse> solveText(String question) async {
    try {
      final response = await _dio.post(
        '/gpt/solve-text',
        data: {
          'question': question,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BackendServiceResponse(
          success: true,
          message: 'Pregunta procesada exitosamente',
          data: response.data,
        );
      }

      return BackendServiceResponse(
        success: false,
        message: _getErrorMessage(response),
      );
    } on DioException catch (e) {
      return BackendServiceResponse(
        success: false,
        message: _handleDioError(e),
      );
    } catch (e) {
      return BackendServiceResponse(
        success: false,
        message: 'Error inesperado: $e',
      );
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de respuesta agotado';
      case DioExceptionType.badResponse:
        return _getErrorMessage(e.response);
      case DioExceptionType.connectionError:
        return 'Error de conexión, verifica tu internet';
      default:
        return 'Error de conexión: ${e.message}';
    }
  }

  String _getErrorMessage(Response? response) {
    if (response?.data is Map) {
      return response?.data['message'] ?? 'Error desconocido';
    }
    return 'Error: ${response?.statusCode}';
  }

  void dispose() {
    _dio.close();
  }
}
