import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../local/shared_pref.dart';
import '../model/Cred.dart';
import '../model/GeneralResponse.dart';
import '../model/TokensModel.dart';
import '../model/User.dart';
import '../service/webClientService.dart';

class Auth extends ChangeNotifier {
  WebClientService _webClient = WebClientService();

  Tokens _tokens = Tokens();

  User? _user;

  Cred? _cred;
  // ignore: unnecessary_getters_setters
  User? get user => _user;
  // ignore: unnecessary_getters_setters
  set user(User? u) => _user = u;
  // ignore: unnecessary_getters_setters
  Cred? get cred => _cred;
  // ignore: unnecessary_getters_setters
  set cred(Cred? u) => _cred = u;

  Tokens get token => _tokens;

  //  Handle Login
  //  Step 1: Get Cookies
  Future<GeneralResponse> login(String username, String? password) async {
    GeneralResponse response = await _webClient.getLoginToken();

    username = username.trim();

    print(response.status);
    if (response.status) {
      _tokens.cookies =
          response.data?.headers?.map['set-cookie']?.elementAt(0) ?? "";

      //  Step 2: Prepare formData for Login
      var document = parse(response.data.data);

      _tokens.viewState =
          document.querySelector('#__VIEWSTATE')!.attributes['value'];
      _tokens.viewStateGenerator =
          document.querySelector('#__VIEWSTATEGENERATOR')!.attributes['value'];
      _tokens.eventValidation =
          document.querySelector('#__EVENTVALIDATION')!.attributes['value'];
      String btnTarget = document.getElementsByTagName('button')[0].id;
      // Form Data for POST
      Map<String, String?> formData = {
        '__LASTFOCUS': '',
        '__EVENTTARGET': btnTarget,
        '__EVENTARGUMENT': '',
        '__VIEWSTATE': _tokens.viewState,
        '__VIEWSTATEGENERATOR': _tokens.viewStateGenerator,
        '__EVENTVALIDATION': _tokens.eventValidation,
        'txtUser': '$username',
        'txtPassword': '$password'
      };
      // Submit login Request
      GeneralResponse postResponse =
          await _webClient.postLogin(formData, _tokens.cookies);
      print(postResponse.data);
      if (postResponse.status) {
        //  Login Success
        return postResponse;
      } else {
        // Invalid Credentials
        return GeneralResponse(
            status: false,
            error: "Invalid Credentials",
            data: postResponse.data);
      }
    } else
      return response;
  }

  Future<void> logout() async {
    LocalData _local = LocalData();
    await _local.setLogout();
  }
}
