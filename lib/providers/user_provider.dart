import 'package:flutter/material.dart';
import 'package:zero_waste/repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  User? _user;
  User? get user => _user;

  Future<void> addUser(User user) async {
    try {
      await _userRepository.addUser(user);
      notifyListeners();
    } catch (e) {
      print('Error in UserProvider: $e');
    }
  }

  Future<void> login(User user) async {
    try {
      User loggedInUser = await _userRepository.login(user);
      _user = loggedInUser;
      notifyListeners();
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }
  
}
