import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";

class UserProvider with ChangeNotifier {
  Future<String> getUserId() async{
    final User user =    FirebaseAuth.instance.currentUser;
    return user.uid;
  }
}
