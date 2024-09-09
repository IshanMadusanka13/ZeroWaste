import 'package:flutter/material.dart';
import 'package:zero_waste/repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  Future<void> addUser(User user) async {
    try {
      await _userRepository.addUser(user);
      notifyListeners();
    } catch (e) {
      print('Error in UserProvider: $e');
    }
  }
}
