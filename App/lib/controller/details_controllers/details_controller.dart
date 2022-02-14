import 'package:flutter/material.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/repository/user_repository.dart';

enum DetailsValidationStatus { ok, tooHeavy, tooLight, emptyFields, noGender, tooTall, tooSmall }

abstract class DetailsController {
  late UserRepository userRepository;

  late String weight;
  late String height;
  late String physicalActivity;

  Gender? gender;

  DetailsController(TextEditingController weight, Gender? gender,
      TextEditingController height, PhysicalActivity physicalActivity) {
    this.weight = weight.text;
    this.gender = gender;
    this.height = height.text;
    this.physicalActivity = physicalActivity.toShortString();
    userRepository = UserRepository();
  }

  //Total Daily Energy Expenditure
  double calculateTDEE(Gender gender, int age, PhysicalActivity activity) {
    double rmr; //Resting Metabolic Rate
    switch (gender) {
      case Gender.Male:
        rmr = (10 * double.parse(weight)) +
            (6.25 * int.parse(height)) -
            (5 * age) +
            5;
        break;
      case Gender.Female:
        rmr = (10 * double.parse(weight)) +
            (6.25 * int.parse(height)) -
            (5 * age) -
            161;
        break;
    }
    switch (activity) {
      case PhysicalActivity.Sedentary_Lifestyle:
        return rmr * 1.2;
      case PhysicalActivity.Lightly_Active_Lifestyle:
        return rmr * 1.375;
      case PhysicalActivity.Moderately_Active_Lifestyle:
        return rmr * 1.55;
      case PhysicalActivity.Very_Active_Lifestyle:
        return rmr * 1.725;
      case PhysicalActivity.Extra_Active_Lifestyle:
        return rmr * 1.9;
    }
  }

  DetailsValidationStatus validate();
}
