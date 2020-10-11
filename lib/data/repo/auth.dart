import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:ipecstudents/data/model/Cred.dart';
import 'package:ipecstudents/data/model/GeneralResponse.dart';
import 'package:ipecstudents/data/model/TokensModel.dart';
import 'package:ipecstudents/data/model/User.dart';
import 'package:ipecstudents/data/service/webClientService.dart';

import '../const.dart';

class Auth extends ChangeNotifier {
  WebClientService _webClient = WebClientService();

  Tokens _tokens = Tokens();

  User _user;

  Cred _cred;

  get user => _user;
  set user(User u) => _user = u;

  get cred => _cred;
  set cred(Cred u) => _cred = u;

  get token => _tokens;

  //  Handle Login
  //  Step 1: Get Cookies
  Future<GeneralResponse> login(String username, String password) async {
    GeneralResponse response = await _webClient.getLoginToken();

    username = username.trim();

    print(response.status);
    if (response.status) {
      _tokens.cookies =
          response?.data?.headers?.map['set-cookie']?.elementAt(0) ?? "";

      //  Step 2: Prepare formData for Login
      var document = parse(response.data.data);

      _tokens.viewState =
          document.querySelector('#__VIEWSTATE').attributes['value'];
      _tokens.viewStateGenerator =
          document.querySelector('#__VIEWSTATEGENERATOR').attributes['value'];
      _tokens.eventValidation =
          document.querySelector('#__EVENTVALIDATION').attributes['value'];
      String btnTarget = document.getElementsByTagName('button')[0].id;
      // Form Data for POST
      Map<String, String> formData = {
        '__LASTFOCUS': '',
        '__EVENTTARGET': btnTarget,
        '__EVENTARGUMENT': '',
        '__VIEWSTATE': _tokens.viewState,
        '__VIEWSTATEGENERATOR': _tokens.viewStateGenerator,
        '__EVENTVALIDATION': _tokens.eventValidation,
        'txtUser': '$username',
        'txtPassword': '$password'
      };

      GeneralResponse postResponse =
          await _webClient.postLogin(formData, _tokens.cookies);
      if (postResponse.status &&
          postResponse.data.request.uri.toString() == kWebsiteURL + kHomeURL) {
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
}
