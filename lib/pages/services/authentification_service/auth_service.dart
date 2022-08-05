import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_one/pages/services/database_service/shared_preferances.dart';
import 'package:flutter/material.dart';
import '../utils_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = userCredential.user;
      await user?.updateDisplayName(name);
      return user;
    } catch (e) {
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }

  static Future<User?> signInUser(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }

  static Future<void> signOutUser(BuildContext context) async {
    await _auth.signOut();
    DBService.removeUserId().then((value) {
    });
  }
}
