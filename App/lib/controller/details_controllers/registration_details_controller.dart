import 'package:flutter/material.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/controller/details_controllers/details_controller.dart';
import 'package:food_app/model/user.dart';
import 'package:intl/intl.dart';

class RegistrationDetailsController extends DetailsController {
  late String _date;

  int get date => int.parse(_date);

  RegistrationDetailsController(
      String date,
      TextEditingController weight,
      Gender? gender,
      TextEditingController height,
      PhysicalActivity physicalActivity)
      : super(weight, gender, height, physicalActivity) {
    this._date = date;
  }

  @override
  DetailsValidationStatus validate() {
    if (_date == '' || weight.isEmpty)
      return DetailsValidationStatus.emptyFields;
    else if (gender == null)
      return DetailsValidationStatus.noGender;
    else if (double.parse(weight) > 300.0)
      return DetailsValidationStatus.tooHeavy;
    else if (double.parse(weight) < 15.0)
      return DetailsValidationStatus.tooLight;
    else if (int.parse(height) > 270)
      return DetailsValidationStatus.tooTall;
    else if (int.parse(height) < 80)
      return DetailsValidationStatus.tooSmall;
    else
      return DetailsValidationStatus.ok;
  }

  Future<void> insertUser(
      String login,
      String password,
      String email,
      String date,
      String weight,
      Gender gender,
      String height,
      PhysicalActivity activity) async {
    DateTime birthDate = DateFormat('dd/MM/yyyy').parse(date);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;
    if (birthDate.month > today.month)
      age--;
    else if (birthDate.month == today.month) {
      if (birthDate.day > today.day) age--;
    }

    final tdee = calculateTDEE(gender, age, activity);

    return await userRepository.insertNewUser(login, password, email, date,
        double.parse(weight), gender, int.parse(height), activity, tdee);
  }
}
