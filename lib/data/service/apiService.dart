// Dio has to be a named import because some of its classes have same
// name as other classes imported from packages in this file.

import 'package:dio/dio.dart' as dio;
import 'package:ipecstudents/data/const.dart';
import 'package:ipecstudents/data/model/GeneralResponse.dart';

class ApiService {
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
      error: false,
      request: false,
      requestBody: false,
      requestHeader: false,
      responseBody: false,
      responseHeader: false,
    ));

  Future<GeneralResponse> getLoginToken() async {
    try {
      final response = await _dio.get(
        kLoginURL,
      );
      return GeneralResponse(data: response, status: true);
    } catch (error) {
      return GeneralResponse(error: error.toString(), status: false);
    }
  }

  // Future<UpcomingMatchesResponse> getUpcomingMatches() async {
  //   try {
  //     final response = await _dio.get(
  //       kApiUpcomingMatches,
  //     );

  //     return UpcomingMatchesResponse.fromJson(response.data);
  //   } catch (error) {
  //     return UpcomingMatchesResponse(status: 'failed');
  //   }
  // }

  // Future<MatchResultResponse> getMatchResult() async {
  //   try {
  //     final response = await _dio.get(
  //       kApiMatchResult,
  //     );

  //     return MatchResultResponse.fromJson(response.data);
  //   } catch (error) {
  //     return MatchResultResponse(status: 'failed');
  //   }
  // }

  // Future<MatchStatsResponse> getMatchStats(
  //   String matchId,
  // ) async {
  //   try {
  //     final response = await _dio.post(kApiMatchStats, data: {'id': matchId});

  //     return MatchStatsResponse.fromJson(response.data);
  //   } catch (error) {
  //     return MatchStatsResponse(status: 'failed');
  //   }
  // }
}
