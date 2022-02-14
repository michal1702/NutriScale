import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/controller/details_controllers/details_controller.dart';
import 'package:food_app/controller/details_controllers/update_details_controller.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/screens/common/dismiss_keyboard_widget.dart';
import 'package:food_app/screens/common/error_widget.dart';
import 'package:food_app/screens/common/input_fields/numbers_input_field.dart';
import 'package:food_app/screens/common/rounded_button.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/register_screen/dropdown_activity_picker_widget.dart';

import '../../../constants.dart';

class UpdateDetailsScreen extends StatefulWidget {
  const UpdateDetailsScreen({
    Key? key,
    required this.size,
    required this.user,
    required this.updateScreen,
  }) : super(key: key);

  final Size size;
  final User user;
  final Function(bool, double, int, String) updateScreen;

  @override
  _UpdateDetailsScreenState createState() => _UpdateDetailsScreenState();
}

class _UpdateDetailsScreenState extends State<UpdateDetailsScreen> {
  AppLocalizations? localization;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _error = '';
  bool _isWeightError = false;
  bool _isHeightError = false;

  PhysicalActivity _physicalActivity = PhysicalActivity.Sedentary_Lifestyle;

  @override
  void initState() {
    super.initState();
    _physicalActivity = widget.user.physicalActivity;
    _weightController.text = widget.user.weight.toString();
    _heightController.text = widget.user.height.toString();
    _weightController.addListener(() {
      _error = '';
      _isWeightError = false;
      _isHeightError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return DismissKeyboard(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25.0),
            Container(
              width: widget.size.width * 0.85,
              child: Column(
                children: [
                  DropdownActivityPicker(
                    size: widget.size,
                    activity: _physicalActivity,
                    onActivitySelect: (activity) {
                      _physicalActivity = stringToActivity(activity);
                    },
                  ),
                  Container(
                    width: widget.size.width * 0.6,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        NumbersInputField(
                          hint: localization!.weight + " [kg]",
                          controller: _weightController,
                          isError: _isWeightError,
                          decimal: true,
                        ),
                        SizedBox(height: 15.0),
                        NumbersInputField(
                          hint: "Height [cm]",
                          controller: _heightController,
                          isError: _isHeightError,
                          decimal: false,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ErrorMessage(text: _error),
            SizedBox(height: 20.0),
            RoundedButton(
                text: localization!.updateDetails,
                action: () {
                  setState(() {
                    _validate();
                  });
                }),
            SizedBox(height: 15.0),
            RoundedButton(
                text: localization!.cancel,
                action: () {
                  widget.updateScreen(false, widget.user.weight,
                      widget.user.height, widget.user.physicalActivityString);
                })
          ],
        ),
      ),
    );
  }

  void _validate() async {
    final UpdateDetailsController updateDetailsController =
        UpdateDetailsController(
            _weightController, null, _heightController, _physicalActivity);
    final validationStatus = updateDetailsController.validate();
    switch (validationStatus) {
      case DetailsValidationStatus.ok:
        await updateDetailsController.updateUserDetails(widget.user);
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Text(
              localization!.detailsChanged,
              style: buildHeaderTextStyle(textWhiteColor),
              textAlign: TextAlign.center,
            ),
            backgroundColor: primaryColor,
          ),
        );
        widget.updateScreen(
            false,
            double.parse(_weightController.text),
            int.parse(_heightController.text),
            _physicalActivity.toShortString());
        break;
      case DetailsValidationStatus.tooHeavy:
        _error = localization!.weightIsLimited;
        _isWeightError = true;
        break;
      case DetailsValidationStatus.emptyFields:
        _error = localization!.fillRequiredFields;
        _isWeightError = true;
        _isHeightError = true;
        break;
      case DetailsValidationStatus.tooTall:
        _error = "Too tall";
        _isHeightError = true;
        break;
      case DetailsValidationStatus.noGender:
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
}
