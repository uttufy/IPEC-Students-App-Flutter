import 'dart:io';

class Tokens {
  String _cookies;
  String _viewState;
  String _viewStateGenerator;
  String _eventValidation;
  set cookies(String c) {
    _cookies = c;
  }

  get cookies => _cookies;
}
