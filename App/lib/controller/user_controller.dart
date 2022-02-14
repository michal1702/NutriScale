import 'package:food_app/model/user.dart';
import 'package:food_app/repository/user_repository.dart';

class UserController{
  late UserRepository _userRepository;

  UserController(){
    _userRepository = UserRepository();
  }

  Future<User?> getUserByLogin(String login){
    return _userRepository.getUserByLogin(login);
  }
}