import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/controller/details_controllers/details_controller.dart';
import 'package:food_app/controller/details_controllers/registration_details_controller.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/screens/common/dismiss_keyboard_widget.dart';
import 'package:food_app/screens/common/error_widget.dart';
import 'package:food_app/screens/common/input_fields/birthday_date_picker.dart';
import 'package:food_app/screens/common/input_fields/numbers_input_field.dart';
import 'package:food_app/screens/common/rounded_button.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/common/top_circle.dart';

import '../../constants.dart';
import 'dropdown_activity_picker_widget.dart';

class RegisterDetailsScreen extends StatefulWidget {
  final String email;
  final String password;
  final String login;

  RegisterDetailsScreen(
      {required this.email, required this.login, required this.password});

  @override
  _RegisterDetailsScreenState createState() =>
      _RegisterDetailsScreenState(email, login, password);
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  _RegisterDetailsScreenState(this._email, this._login, this._password);

  final String _email;
  final String _login;
  final String _password;

  AppLocalizations? localization;

  final _heightController = TextEditingController();

  final _weightController = TextEditingController();

  String _error = '';
  String _date = '';

  Gender? _gender;

  bool _isDateError = false;
  bool _isWeightError = false;
  bool _isHeightError = false;
  bool _isProcessing = false;

  PhysicalActivity _physicalActivity = PhysicalActivity.Sedentary_Lifestyle;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(() {
      _error = "";
      _isWeightError = false;
      _isHeightError = false;
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
        body: _isProcessing
            ? SpinKitFoldingCube(
                size: 80.0,
                color: primaryColor,
              )
            : Stack(
                children: <Widget>[
                  TopCircle(
                    size: size,
                    title: localization!.details,
                  ),
                  Align(
                    alignment: FractionalOffset(0.5, 1),
                    child: Container(
                      height: size.height * 0.8,
                      width: size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: size.width * 0.9,
                            child: Column(
                              children: <Widget>[
                                BirthdayDatePicker(
                                    size: size,
                                    isError: _isDateError,
                                    onDateSelect: (pickedDate) {
                                      _date = pickedDate;
                                    }),
                                SizedBox(height: 20.0),
                                DropdownActivityPicker(
                                  size: size,
                                  onActivitySelect: (activity) {
                                    _physicalActivity =
                                        stringToActivity(activity);
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                              width: size.width * 0.7,
                              child: Column(
                                children: <Widget>[
                                  NumbersInputField(
                                      hint: localization!.weight + " [kg]",
                                      controller: _weightController,
                                      decimal: true,
                                      isError: _isWeightError),
                                  SizedBox(height: 20.0),
                                  NumbersInputField(
                                      hint: "Height [cm]",
                                      controller: _heightController,
                                      decimal: false,
                                      isError: _isHeightError),
                                ],
                              )),
                          SizedBox(height: 20.0),
                          Column(
                            children: [
                              Text(
                                localization!.gender,
                                style: buildHeaderTextStyle(textBlackColor),
                              ),
                              Container(
                                //color: Colors.black,
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: buildRadioButton(Gender.Female),
                                    ),
                                    Flexible(
                                      child: buildRadioButton(Gender.Male),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          ErrorMessage(text: _error),
                          SizedBox(height: 20.0),
                          RoundedButton(
                            text: localization!.create,
                            action: () {
                              setState(() {
                                _validate();
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          RoundedButton(
                            text: localization!.back,
                            action: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future<void> insertData(RegistrationDetailsController controller) async {
    controller.insertUser(_login, _password, _email, _date, controller.weight,
        controller.gender!, controller.height, _physicalActivity);
  }

  void _validate() async {
    final _registrationDetailsController = RegistrationDetailsController(
        _date, _weightController, _gender, _heightController, _physicalActivity);
    final _validationStatus = _registrationDetailsController.validate();
    switch (_validationStatus) {
      case DetailsValidationStatus.ok:
        _isProcessing = true;
        await insertData(_registrationDetailsController);
        Future.delayed(const Duration(milliseconds: 1000), () {
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(
                localization!.createdAnAccount,
                style: buildHeaderTextStyle(textWhiteColor),
                textAlign: TextAlign.center,
              ),
              backgroundColor: primaryColor,
            ),
          );
          Navigator.popUntil(context, ModalRoute.withName('/'));
        });
        break;
      case DetailsValidationStatus.tooHeavy:
        _error = localization!.weightIsLimited;
        _isWeightError = true;
        break;
      case DetailsValidationStatus.emptyFields:
        _error = localization!.fillRequiredFields;
        _isDateError = true;
        _isWeightError = true;
        break;
      case DetailsValidationStatus.noGender:
        _error = localization!.chooseGender;
        break;
      case DetailsValidationStatus.tooTall:
        _error = "Too tall";
        _isHeightError = true;
        break;
      case DetailsValidationStatus.tooLight:
        _error = "Too light";
        _isWeightError = true;
        break;
      case DetailsValidationStatus.tooSmall:
        _error = "Too small";
        _isHeightError = true;
        break;
    }
  }

  Container buildRadioButton(Gender gender) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 1.2,
            child: Radio<Gender>(
              activeColor: primaryColor,
              value: gender,
              groupValue: _gender,
              onChanged: (Gender? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
          ),
          Text(
            gender == Gender.Male ? localization!.male : localization!.female,
            style: buildBigTextStyle(textBlackColor),
          ),
        ],
      ),
    );
  }
}
