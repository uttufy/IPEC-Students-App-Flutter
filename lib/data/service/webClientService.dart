// Dio has to be a named import because some of its classes have same
// name as other classes imported from packages in this file.

import 'package:dio/dio.dart' as dio;
import 'package:ipecstudents/data/const.dart';
import 'package:ipecstudents/data/model/GeneralResponse.dart';

class WebClientService {
  static const String xAccessToken = 'x-access-token';

  /// Dio is a networking client that add a lot of features on
  /// top of the http library.
  /// With features such as common options for all requests,
  /// interceptors, etc, dio makes it easier to make network requests.
  /// It also results in a lot less code.
  final _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: kWebsiteURL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  )..interceptors.add(dio.LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));

  Future<GeneralResponse> getLoginToken() async {
    try {
      final response = await _dio.get(
        kLoginURL,
      );
      if (response.statusCode == 200)
        return GeneralResponse(data: response, status: true);
      else
        return GeneralResponse(error: "Something went wrong!", status: false);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }
}
