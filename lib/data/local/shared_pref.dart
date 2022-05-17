import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'saver_keys.dart';

class LocalData {
  static final LocalData _singleton = LocalData._internal();

  factory LocalData() {
    return _singleton;
  }

  LocalData._internal();

  final kUsername = 'username';
  final kPassword = 'password';
  final kName = 'name';
  final kImage = 'userImage';
  final kLoginStatus = 'userImage';
  final kCookie = 'cookie';
  Future<void> saveUserPreference(
      String username, String password, String name, String userImage,
      {bool loginStatus = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // FIXME: REMOVE LINE BELOW INORDER TO BUILD
    removeMeInOrderToBuild(
        kUsername, kPassword, username, password, kName, name);
    prefs.setString(kUsername, username);
    prefs.setString(kPassword, password);
    prefs.setString(kName, name);
    prefs.setString(kImage, userImage);
    prefs.setBool(kLoginStatus, loginStatus);
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(kUsername) as FutureOr<String?>;
  }

  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(kPassword) as FutureOr<String?>;
  }

  Future<String?> getImagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(kImage) as FutureOr<String?>;
  }

  Future<String?> getNamePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(kName) as FutureOr<String?>;
  }

  Future<void> setLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLoginStatus, false);
  }

  Future<void> saveCookie(String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(kCookie, cookie);
  }

  Future<String?> getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(kCookie) as FutureOr<String?>;
  }

  Future<bool?> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(kLoginStatus) as FutureOr<bool?>;
  }
}
