import 'package:dio/dio.dart';

import '../utils/app_logger.dart';

Dio createDioClient() {
  final dio = Dio();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.logApi('🔵 [API REQUEST]');
        AppLogger.logApi('URL: \'${options.uri}\'');
        AppLogger.logApi('Method: \'${options.method}\'');
        AppLogger.logApi('Query: \'${options.queryParameters}\'');
        AppLogger.logApi('Headers: \'${options.headers}\'');
        handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.logApi('🟢 [API RESPONSE]');
        AppLogger.logApi('Status: \'${response.statusCode}\'');
        AppLogger.logApi('Data: \'${response.data}\'');
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.logError('🔴 [API ERROR]');
        AppLogger.logError('Message: \'${error.message}\'');
        AppLogger.logError('Response: \'${error.response?.data}\'');
        handler.next(error);
      },
    ),
  );

  return dio;
}
