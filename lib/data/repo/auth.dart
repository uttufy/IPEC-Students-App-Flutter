import 'package:ipecstudents/data/model/GeneralResponse.dart';
import 'package:ipecstudents/data/model/TokensModel.dart';
import 'package:ipecstudents/data/service/webClientService.dart';

class Auth {
  WebClientService _webClient = WebClientService();

  Tokens _tokens = Tokens();

  //    Handle Login
  Future<GeneralResponse> login(String username, String password) async {
    GeneralResponse response = await _webClient.getLoginToken();

    if (response.status) {
      _tokens.cookies = response.data.headers.map['set-cookie'].elementAt(0);
    } else
      return response;
  }
}
