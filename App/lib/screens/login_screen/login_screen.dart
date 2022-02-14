import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/config/current_user.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/controller/login_controller.dart';
import 'package:food_app/controller/user_controller.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/screens/common/dismiss_keyboard_widget.dart';
import 'package:food_app/screens/common/error_widget.dart';
import 'package:food_app/screens/common/input_fields/text_input_field.dart';
import 'package:food_app/screens/common/top_circle.dart';
import 'package:food_app/screens/login_screen/sign_up_container.dart';

import '../common/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  AppLocalizations? localization;

  final _loginController = TextEditingController();

  final _passwordController = TextEditingController();

  String _error = "";

  bool _isError = false;

  bool _isProcessing = false;

  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _loginController.addListener(() {
      _error = "";
      _isError = false;
    });
    _passwordController.addListener(() {
      _error = "";
      _isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    localization = AppLocalizations.of(context)!;
    return DismissKeyboard(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: _isProcessing
            ? SpinKitFoldingCube(
                size: 80.0,
                color: primaryColor,
              )
            : Stack(
                children: <Widget>[
                  TopCircle(
                      size: size,
                      title: localization!.appTitle,
                      subTitle: localization!.appSubTitle),
                  Align(
                    alignment: FractionalOffset(0.5, 0.75),
                    child: Container(
                      height: size.height * 0.5,
                      width: size.width * 0.8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextInputField(
                              hint: localization!.login,
                              isSensitive: false,
                              controller: _loginController,
                              isError: _isError,
                            ),
                            SizedBox(height: 20.0),
                            TextInputField(
                              hint: localization!.password,
                              isSensitive: true,
                              controller: _passwordController,
                              isError: _isError,
                            ),
                            SizedBox(height: 25.0),
                            RoundedButton(
                              text: localization!.signIn,
                              action: () async {
                                await _validate();
                              },
                            ),
                            SizedBox(height: 15.0),
                            _isValidating
                                ? Flexible(
                                    child: SpinKitFadingCircle(
                                    size: 40.0,
                                    color: primaryColor,
                                  ))
                                : ErrorMessage(text: _error),
                            SizedBox(height: 15.0),
                            SignUpContainer(
                                size: size,
                                text: localization!.doNotHaveAnAccount),
                          ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _validate() async {
    setState(() {
      _isValidating = true;
    });
    final _loginValidationController =
        LoginController(_loginController, _passwordController);

    final _loginValidationStatus = await _loginValidationController.validateInput();

    switch (_loginValidationStatus) {
      case LoginValidationStatus.ok:
        setState(() {
          _isProcessing = true;
        });
        UserController userController = UserController();
        User user = (await userController
            .getUserByLogin(this._loginController.text.toString()))!;
        CurrentUser.user = user;
        await Navigator.pushNamed(context, '/menu');
        _loginController.clear();
        _passwordController.clear();
        setState(() {
          _isProcessing = false;
        });
        break;
      case LoginValidationStatus.emptyFields:
        _error = localization!.fillRequiredFields;
        _isError = true;
        break;
      case LoginValidationStatus.loginDoesNotExist:
        _error = localization!.accountDoesNotExist;
        _isError = true;
        break;
      case LoginValidationStatus.wrongPassword:
        _error = localization!.wrongPassword;
        _isError = true;
        break;
    }
    setState(() {
      _isValidating = false;
    });
  }
}
