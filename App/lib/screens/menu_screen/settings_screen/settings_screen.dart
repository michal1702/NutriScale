import 'package:flutter/material.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/screens/common/rounded_button.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/menu_screen/settings_screen/update_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({
    Key? key,
    required this.user,
    required this.size,
  }) : super(key: key);

  final Size size;
  final double padding = 10.0;
  final User user;

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  AppLocalizations? localization;
  Color _buttonColor = textBlackColor;
  String _passwordHidden = '';
  bool _showPassword = false;
  bool _updateScreen = false;

  @override
  void initState() {
    super.initState();
    _passwordHidden = _generatePasswordDots();
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: _updateScreen
          ? UpdateDetailsScreen(
              size: size,
              user: widget.user,
              updateScreen: (updateScreen, weight, height, activity) {
                setState(() {
                  _updateScreen = updateScreen;
                  widget.user.weight = weight;
                  widget.user.height = height;
                  widget.user.physicalActivity = stringToActivity(activity);
                });
              },
            )
          : Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Text(
                    localization!.credentials,
                    style: buildHeaderTextStyle(textBlackColor),
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.only(left: widget.padding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${localization!.login}:  ${widget.user.userCredentials.login}',
                            style: buildMediumTextStyle(textLighterBlackColor),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            '${localization!.email}:  ${widget.user.userCredentials.email}',
                            style: buildMediumTextStyle(textLighterBlackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.padding, right: widget.padding),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${localization!.password}:  ${_showPassword ? widget.user.userCredentials.password : _passwordHidden}',
                          style: buildMediumTextStyle(textLighterBlackColor),
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 30.0,
                            ),
                            color: _buttonColor,
                            onPressed: () {
                              setState(
                                () {
                                  if (_buttonColor == textBlackColor) {
                                    _buttonColor = primaryColor;
                                    _showPassword = true;
                                  } else {
                                    _buttonColor = textBlackColor;
                                    _showPassword = false;
                                  }
                                },
                              );
                            })
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(localization!.details, style: buildHeaderTextStyle(textBlackColor)),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.only(left: widget.padding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${localization!.age}:  ${widget.user.age}',
                              style: buildMediumTextStyle(textLighterBlackColor)),
                          SizedBox(height: 10.0),
                          Text('${localization!.weight}:  ${widget.user.weight}',
                              style: buildMediumTextStyle(textLighterBlackColor)),
                          SizedBox(height: 10.0),
                          Text('Height:  ${widget.user.height}',
                              style: buildMediumTextStyle(textLighterBlackColor)),
                          SizedBox(height: 10.0),
                          Text('Activity:  ${widget.user.physicalActivityString}',
                              style: buildMediumTextStyle(textLighterBlackColor)),
                        ],
                      ),
                    ),
                  ),


                  /*SizedBox(height: 40.0),
                  RoundedButton(text: 'Change password', action: () {}),*/ //Uncomment later


                  SizedBox(height: 20.0),
                  RoundedButton(
                      text: localization!.updateDetails,
                      action: () {
                        setState(() {
                          _updateScreen = true;
                        });
                      })
                ],
              ),
            ),
    );
  }

  String _generatePasswordDots() {
    int dotsCount = widget.user.userCredentials.password.length;
    String hiddenPassword = '';
    for (int i = 0; i < dotsCount; i++) {
      hiddenPassword = hiddenPassword + '*';
    }
    return hiddenPassword;
  }
}
