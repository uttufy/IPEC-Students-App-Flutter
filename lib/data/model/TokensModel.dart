import 'dart:io';

class Tokens {
  String _cookies;
  String _viewState;
  String _viewStateGenerator;
  String _eventValidation;

  set cookies(String c) {
    _cookies = c;
  }

  set viewState(String c) {
    _viewState = c;
  }

  set viewStateGenerator(String c) {
    _viewStateGenerator = c;
  }

  set eventValidation(String c) {
    _eventValidation = c;
  }

  get cookies => _cookies;

  get viewState => _viewState;

  get viewStateGenerator => _viewStateGenerator;

  get eventValidation => _eventValidation;
}
