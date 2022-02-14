import 'package:flutter/material.dart';
import 'package:food_app/repository/user_repository.dart';

enum CredentialsValidationStatus {
  ok,
  differentPasswords,
  loginExists,
  passwordToShort,
  emptyField,
  emailExists,
  wrongEmail
}

abstract class CredentialsController {
  late UserRepository userRepository;

  late String login;
  late String password;
  late String email;

  CredentialsController(TextEditingController login,
      TextEditingController password, TextEditingController email) {
    this.login = login.text;
    this.password = password.text;
    this.email = email.text;
    userRepository = UserRepository();
  }

  Future<CredentialsValidationStatus> validate();

  bool ifEmailIsValid() {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(email))
      return false;
    else
      return true;
  }
}
