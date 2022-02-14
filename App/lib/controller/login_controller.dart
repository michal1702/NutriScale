import 'package:flutter/material.dart';
import 'package:food_app/repository/user_repository.dart';

enum LoginValidationStatus { ok, emptyFields, loginDoesNotExist, wrongPassword }

class LoginController {
  late UserRepository _userRepository;

  late String _login;
  late String _password;

  LoginController(TextEditingController login, TextEditingController password) {
    this._login = login.text;
    this._password = password.text;
    _userRepository = UserRepository();
  }

  Future<LoginValidationStatus> validateInput() async {
    if (_login.isEmpty || _password.isEmpty)
      return LoginValidationStatus.emptyFields;
    else if (!await _userRepository.ifLoginExists(_login))
      return LoginValidationStatus.loginDoesNotExist;
    else if (!await _userRepository.ifCredentialsAreCorrect(_login, _password))
      return LoginValidationStatus.wrongPassword;
    else
      return LoginValidationStatus.ok;
  }
}
