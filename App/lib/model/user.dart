import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/model/user_credentials.dart';
import 'package:intl/intl.dart';

enum Gender { Male, Female }

class User {
  User(this._birthDate, this._weight, this._gender, this._height,
      this._physicalActivity, this._tdee, this._userCredentials);

  Gender _gender;
  String _birthDate;
  double _weight;
  int _height;
  PhysicalActivity _physicalActivity;
  double _tdee;
  UserCredentials _userCredentials;

  Gender get gender => _gender;

  PhysicalActivity get physicalActivity => _physicalActivity;

  String get physicalActivityString => _physicalActivity.toShortString();

  double get weight => _weight;

  int get height => _height;

  double get tdee => _tdee;

  int get age {
    DateTime birthDate = DateFormat('dd/MM/yyyy').parse(_birthDate);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;
    if (birthDate.month > today.month)
      age--;
    else if (birthDate.month == today.month) {
      if (birthDate.day > today.day) age--;
    }
    return age;
  }

  set height(int value) {
    _height = value;
  }

  set weight(double value) {
    _weight = value;
  }

  set physicalActivity(PhysicalActivity value) {
    _physicalActivity = value;
  }

  set tdee(double value) {
    _tdee = value;
  }

  UserCredentials get userCredentials => _userCredentials;

  factory User.fromMap(
      Map<dynamic, dynamic> userDetails, UserCredentials userCredentials) {
    Gender gender =
        userDetails['Gender'] == 'Male' ? Gender.Male : Gender.Female;
    double weight = double.parse(userDetails['Weight']);
    int height = int.parse(userDetails['Height']);
    double tdee = double.parse(userDetails['TDEE']);
    PhysicalActivity activity =
        stringToActivity(userDetails['PhysicalActivity']);
    return User(userDetails['BirthDate'], weight, gender, height, activity,
        tdee, userCredentials);
  }

  Map toJson() => {
        'Details': {
          'Gender': this._gender.toString().split('.').last,
          'BirthDate': this._birthDate,
          'Weight': this._weight.toStringAsFixed(2),
          'Height': this._height.toString(),
          'PhysicalActivity': this._physicalActivity.toShortString(),
          'TDEE': this._tdee.toStringAsFixed(5)
        },
        'Credentials': this._userCredentials.toJson(),
      };
}
