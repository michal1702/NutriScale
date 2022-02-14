import 'package:flutter/material.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/controller/details_controllers/details_controller.dart';
import 'package:food_app/model/user.dart';

class UpdateDetailsController extends DetailsController {
  UpdateDetailsController(TextEditingController weight, Gender? gender,
      TextEditingController height, PhysicalActivity physicalActivity)
      : super(weight, gender, height, physicalActivity);

  @override
  DetailsValidationStatus validate() {
    if (weight.isEmpty || height.isEmpty)
      return DetailsValidationStatus.emptyFields;
    else if (double.parse(weight) > 300.0)
      return DetailsValidationStatus.tooHeavy;
    else if (int.parse(height) > 270)
      return DetailsValidationStatus.tooTall;
    else if (int.parse(height) < 80)
      return DetailsValidationStatus.tooSmall;
    else if (double.parse(weight) < 15.0)
      return DetailsValidationStatus.tooLight;
    else
      return DetailsValidationStatus.ok;
  }

  Future<void> updateUserDetails(User user) async {
    final tdee = calculateTDEE(user.gender, user.age, user.physicalActivity);
    userRepository.updateUserDetails(double.parse(weight), int.parse(height),
        user.userCredentials.login, stringToActivity(physicalActivity), tdee);
  }
}
