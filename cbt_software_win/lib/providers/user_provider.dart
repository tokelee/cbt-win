import 'package:cbt_software_win/core/helper/user_state_object.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  final UserState _userStateItems = userState;

 UserState get userStateItems => _userStateItems;

  void setUserState({
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    userStateItems.firstName = firstName;
    userStateItems.lastName = lastName;
    userStateItems.username = username;
    notifyListeners();
  }

}