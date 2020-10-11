import 'package:html/parser.dart';
import 'package:ipecstudents/data/model/GeneralResponse.dart';
import 'package:ipecstudents/data/model/TokensModel.dart';
import 'package:ipecstudents/data/service/webClientService.dart';

class Auth {
  WebClientService _webClient = WebClientService();

  Tokens _tokens = Tokens();

  //  Handle Login

  //  Step 1: Get Cookies
  Future<GeneralResponse> login(String username, String password) async {
    GeneralResponse response = await _webClient.getLoginToken();

    if (response.status) {
      _tokens.cookies = response.data.headers.map['set-cookie'].elementAt(0);

      //  Step 2: Prepare formData for Login
      var document = parse(response.data.data);

      _tokens.viewState =
          document.querySelector('#__VIEWSTATE').attributes['value'];
      _tokens.viewStateGenerator =
          document.querySelector('#__VIEWSTATEGENERATOR').attributes['value'];
      _tokens.eventValidation =
          document.querySelector('#__EVENTVALIDATION').attributes['value'];
    } else
      return response;
  }
}
