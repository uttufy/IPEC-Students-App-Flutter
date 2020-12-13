// Dio has to be a named import because some of its classes have same
// name as other classes imported from packages in this file.

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:ipecstudentsapp/data/const.dart';
import 'package:ipecstudentsapp/data/model/Cred.dart';
import 'package:ipecstudentsapp/data/model/GeneralResponse.dart';
import 'package:ipecstudentsapp/data/model/TokensModel.dart';

class WebClientService {
  static final WebClientService _singleton = WebClientService._internal();

  factory WebClientService() {
    return _singleton;
  }

  WebClientService._internal();

  /// Dio is a networking client that add a lot of features on
  /// top of the http library.
  /// With features such as common options for all requests,
  /// interceptors, etc, dio makes it easier to make network requests.
  /// It also results in a lot less code.
  final _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: kWebsiteURL,
      connectTimeout: 300000,
      receiveTimeout: 30000,
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
        await Future.delayed(Duration(milliseconds: 10));
        GeneralResponse res = await getHome();
        return res;
      } else
        return GeneralResponse(error: "Wrong Credentials", status: false);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }

  Future<GeneralResponse> getAttendanceToken(Cred cred, Tokens tokens) async {
    _dio.options.headers['Cookie'] = tokens.cookies;
    _dio.options.headers['Referer'] = kWebsiteURL + kHomeURL;
    _dio.options.headers['Connection'] = 'keep-alive';

    try {
      final response = await _dio.get(
        kAttendanceURL,
      );
      if (response.statusCode == 200)
        return GeneralResponse(data: response, status: true);
      else
        return GeneralResponse(
            error: "Failed to load attendance. Error at first get.",
            status: false);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }

  Future<GeneralResponse> postAttendance(
      Cred cred, Tokens tokens, Map body) async {
    _dio.options.headers['Cookie'] = tokens.cookies;
    _dio.options.headers['Referer'] = kWebsiteURL + kHomeURL;
    _dio.options.headers['Connection'] = 'keep-alive';

    try {
      final response = await _dio.post(kAttendanceURL,
          data: body,
          options:
              new Options(contentType: "application/x-www-form-urlencoded"));
      if (response.statusCode == 200)
        return GeneralResponse(data: response, status: true);
      else
        return GeneralResponse(
            error: "Failed to load attendance. Error at post", status: false);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }

  Future<GeneralResponse> getNotices(String cookie) async {
    _dio.options.headers['Cookie'] = cookie;
    _dio.options.headers['Referer'] = kWebsiteURL + kHomeURL;
    _dio.options.headers['Connection'] = 'keep-alive';

    try {
      final response = await _dio.get(
        kNoticesURL,
      );
      if (response.statusCode == 200)
        return GeneralResponse(data: response, status: true);
      else
        return GeneralResponse(
            error: "Failed to sync notices. Error at first get.",
            status: false);
    } catch (error) {
      return GeneralResponse(
          error: "Notice Sync : " + error.toString(), status: false);
    }
  }
}
