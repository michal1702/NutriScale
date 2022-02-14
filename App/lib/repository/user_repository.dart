import 'package:firebase_database/firebase_database.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/model/user_credentials.dart';

class UserRepository {
  final _databaseReference = FirebaseDatabase.instance.reference();

  Future<User?> getUserByLogin(String login) async {
    final snapshot =
        await _databaseReference.child("Users").child(login).once();

    if (snapshot.value == null) return null;
    try {
      Map<dynamic, dynamic> user = snapshot.value;
      UserCredentials userCredentials = UserCredentials(
          user['Credentials']['login'],
          user['Credentials']['password'],
          user['Credentials']['email']);
      return User.fromMap(user['Details'], userCredentials);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> insertNewUser(String login, String password, String email,
      String date, double weight, Gender gender, int height, PhysicalActivity activity, double tdee) async {
    final userCredentials = UserCredentials(login, password, email);
    final user = User(date, weight, gender, height, activity, tdee, userCredentials);
    await _databaseReference.child("Users").child(login).set(user.toJson());
  }

  Future<void> updateUserDetails(
      double weight, int height, String login, PhysicalActivity activity, double tdee) async {
    Map<String, dynamic> detailsMap = Map();
    detailsMap['Weight'] = weight.toStringAsFixed(2);
    detailsMap['Height'] = height.toString();
    detailsMap['PhysicalActivity'] = activity.toShortString();
    detailsMap['TDEE'] = tdee.toStringAsFixed(5);
    await _databaseReference.child("Users").child(login).child("Details").update(detailsMap);
  }

  Future<bool> ifLoginExists(String login) async {
    final snapshot =
        await _databaseReference.child("Users").child(login).once();
    if (snapshot.value == null)
      return false;
    else
      return true;
  }

  Future<bool> ifCredentialsAreCorrect(String login, String password) async {
    DataSnapshot snapshot = await _databaseReference.child("Users").once();
    if (snapshot.value == null) return false;
    Map<dynamic, dynamic> users = snapshot.value;
    for (var user in users.values) {
      Map<dynamic, dynamic> credentials = user['Credentials'];
      if (login == credentials['login'] && password == credentials['password'])
        return true;
    }
    return false;
  }

  Future<bool> ifEmailExists(String email) async {
    DataSnapshot snapshot = await _databaseReference.child("Users").once();
    if (snapshot.value == null) return false;
    Map<dynamic, dynamic> users = snapshot.value;
    for (var user in users.values) {
      Map<dynamic, dynamic> credentials = user['Credentials'];
      if (email == credentials['email']) return true;
    }
    return false;
  }
}
