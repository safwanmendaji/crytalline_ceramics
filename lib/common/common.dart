import 'dart:convert';

import 'package:myshop_app/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  Future<UserData?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');

      if (userJson != null) {
        Map<String, dynamic> userMap = jsonDecode(userJson);

        return UserData.fromJson(userMap);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }
}
