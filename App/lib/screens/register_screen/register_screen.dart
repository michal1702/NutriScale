import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/controller/credentials_controllers/credentials_controller.dart';
import 'package:food_app/controller/credentials_controllers/registration_credentials_controller.dart';
import 'package:food_app/screens/common/dismiss_keyboard_widget.dart';
import 'package:food_app/screens/common/error_widget.dart';
import 'package:food_app/screens/common/input_fields/email_input_field.dart';
import 'package:food_app/screens/common/input_fields/text_input_field.dart';
import 'package:food_app/screens/common/rounded_button.dart';
import 'package:food_app/screens/common/top_circle.dart';
import 'package:food_app/screens/register_screen/register_details_screen.dart';

import '../../constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AppLocalizations? localization;

  final _loginController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _retypePasswordController = TextEditingController();

  String _error = "";

  bool _isLoginError = false;
  bool _isPasswordError = false;
  bool _isEmailError = false;

  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _loginController.addListener(() {
      _error = "";
      _isLoginError = false;
    });
    _passwordController.addListener(() {
      _error = "";
      _isPasswordError = false;
    });
    _retypePasswordController.addListener(() {
      _error = "";
      _isPasswordError = false;
    });
    _emailController.addListener(() {
      _error = "";
      _isEmailError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    Size size = MediaQuery.of(context).size;
    return DismissKeyboard(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          body: Stack(
            children: <Widget>[
              TopCircle(
                size: size,
                title: localization!.signUp,
              ),
              Align(
                alignment: FractionalOffset(0.5, 0.6),
                child: Container(
                  height: size.height * 0.7,
                  width: size.width * 0.8,
                  child: Column(
                    children: <Widget>[
                      TextInputField(
                        hint: localization!.login,
                        controller: _loginController,
                        isError: _isLoginError,
                      ),
                      SizedBox(height: 20.0),
                      EmailInputField(
                        hint: localization!.email,
                        controller: _emailController,
                        isError: _isEmailError,
                      ),
                      SizedBox(height: 20.0),
                      TextInputField(
                        hint: localization!.password,
                        isSensitive: true,
                        controller: _passwordController,
                        isError: _isPasswordError,
                      ),
                      SizedBox(height: 20.0),
                      TextInputField(
                        hint: localization!.retypePassword,
                        isSensitive: true,
                        controller: _retypePasswordController,
                        isError: _isPasswordError,
                      ),
                      SizedBox(height: 25.0),
                      _isValidating
                          ? Flexible(
                              child: SpinKitFadingCircle(
                              size: 40.0,
                              color: primaryColor,
                            ))
                          : ErrorMessage(text: _error),
                      SizedBox(height: 15.0),
                      RoundedButton(
                          text: localization!.next,
                          action: () async {
                            await _validate();
                            setState(() {});
                          }),
                      SizedBox(height: 15.0),
                      RoundedButton(
                          text: localization!.back,
                          action: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> _validate() async {
    _isValidating = true;
    setState(() {});
    final _registrationController = RegistrationController(_loginController,
        _passwordController, _retypePasswordController, _emailController);
    final validationStatus = await _registrationController.validate();
    switch (validationStatus) {
      case CredentialsValidationStatus.ok:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterDetailsScreen(
                email: _registrationController.email,
                login: _registrationController.login,
                password: _registrationController.password,
              ),
            ));
        break;
      case CredentialsValidationStatus.emptyField:
        _error = localization!.fillRequiredFields;
        _isLoginError = true;
        _isPasswordError = true;
        _isEmailError = true;
        break;
      case CredentialsValidationStatus.differentPasswords:
        _error = localization!.passwordsDoNotMatch;
        _isPasswordError = true;
        break;
      case CredentialsValidationStatus.loginExists:
        _error = localization!.loginExists;
        _isLoginError = true;
        break;
      case CredentialsValidationStatus.passwordToShort:
        _error = localization!.passwordIsTooShort;
        _isPasswordError = true;
        break;
      case CredentialsValidationStatus.emailExists:
        _error = localization!.givenEmailAlreadyExists;
        _isEmailError = true;
        break;
      case CredentialsValidationStatus.wrongEmail:
        _error = localization!.wrongEmail;
        _isEmailError = true;
        break;
    }
    _isValidating = false;
  }
}
