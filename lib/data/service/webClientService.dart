// Dio has to be a named import because some of its classes have same
// name as other classes imported from packages in this file.

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:ipecstudents/data/const.dart';
import 'package:ipecstudents/data/model/GeneralResponse.dart';

class WebClientService {
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
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
    ),
  )..interceptors.add(dio.LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: false,
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

  Future<GeneralResponse> getHome() async {
    try {
      final response = await _dio.get(
        kHomeURL,
      );
      if (response.statusCode == 200)
        return GeneralResponse(data: response, status: true);
      else
        return GeneralResponse(
            error: "Session may be expired! Please Re-Login", status: false);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }

  Future<GeneralResponse> postLogin(
      Map<String, String> body, String cookie) async {
    _dio.options.headers['Cookie'] = cookie;
    _dio.options.headers['Referer'] = kWebsiteURL + kLoginURL;
    try {
      var response = await _dio.post(kLoginURL,
          data: body,
          options:
              new Options(contentType: "application/x-www-form-urlencoded"));
      if (response.statusCode == 302) {
        GeneralResponse res = await getHome();
        return res;
      } else
        return GeneralResponse(error: "Wrong Credentials", status: false);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }
}
