import 'package:flutter/material.dart';
import 'package:food_app/controller/credentials_controllers/credentials_controller.dart';

class RegistrationController extends CredentialsController {
  late String _retypePassword;

  RegistrationController(
      TextEditingController login,
      TextEditingController password,
      TextEditingController retypePassword,
      TextEditingController email)
      : super(login, password, email) {
    this._retypePassword = retypePassword.text;
  }

  @override
  Future<CredentialsValidationStatus> validate() async {
    if (login.isEmpty ||
        password.isEmpty ||
        _retypePassword.isEmpty ||
        email.isEmpty)
      return CredentialsValidationStatus.emptyField;
    else if (await userRepository.ifLoginExists(login))
      return CredentialsValidationStatus.loginExists;
    else if (password.length < 8)
      return CredentialsValidationStatus.passwordToShort;
    else if (password.toString() != _retypePassword.toString())
      return CredentialsValidationStatus.differentPasswords;
    else if (!ifEmailIsValid())
      return CredentialsValidationStatus.wrongEmail;
    else if (await userRepository.ifEmailExists(email))
      return CredentialsValidationStatus.emailExists;
    else {
      return CredentialsValidationStatus.ok;
    }
  }
}
