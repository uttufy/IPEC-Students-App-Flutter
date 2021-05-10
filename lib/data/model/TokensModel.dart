class Tokens {
  String _cookies;
  String _viewState;
  String _viewStateGenerator;
  String _eventValidation;

  // ignore: unnecessary_getters_setters
  set cookies(String c) {
    _cookies = c;
  }

  // ignore: unnecessary_getters_setters
  set viewState(String c) {
    _viewState = c;
  }

  // ignore: unnecessary_getters_setters
  set viewStateGenerator(String c) {
    _viewStateGenerator = c;
  }

  // ignore: unnecessary_getters_setters
  set eventValidation(String c) {
    _eventValidation = c;
  }

  // ignore: unnecessary_getters_setters
  get cookies => _cookies;
  // ignore: unnecessary_getters_setters
  get viewState => _viewState;
  // ignore: unnecessary_getters_setters
  get viewStateGenerator => _viewStateGenerator;
  // ignore: unnecessary_getters_setters
  get eventValidation => _eventValidation;
}
