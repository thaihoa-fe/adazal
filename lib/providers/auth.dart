import 'dart:convert';

import 'package:adazal_app/repositories/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  AuthRepository _repository = AuthRepository();

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData'));

      if (userData == null) {
        return false;
      }

      final expiryDate = DateTime.parse(userData['expiryDate']);

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = userData['token'];
      _expiryDate = expiryDate;
      _userId = userData['userId'];
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final responseBody =
        await _repository.authenticate(email, password, urlSegment);

    _token = responseBody['idToken'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ),
    );
    _userId = responseBody['localId'];
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'expiryDate': _expiryDate.toIso8601String(),
      'userId': _userId,
    });
    await prefs.setString('userData', userData);
  }

  Future<void> signUp(String email, String password) async {
    await authenticate(email, password, 'signUp');
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await authenticate(email, password, 'signInWithPassword');
    notifyListeners();
  }

  void signOut() async {
    _userId = null;
    _expiryDate = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }
}
