import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String _userName;

  // String get token
  bool isAuthenti;

// right one
  // bool get isAuth {
  //   return token != null;
  // }
  bool get isAuth {
    return _userId != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userName {
    return _userName;
  }

  String get userId {
    return _userId;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      final userData = await user.getIdToken(refresh: true);

      _userName = user.displayName;
      _token = userData.token;
      _userId = currentUser.uid;
      _expiryDate = userData.expirationTime;

      // _autoLogout();
      notifyListeners();

      //store persistent data on phone
      final prefs = await SharedPreferences.getInstance();
      final userPref = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'userName': _userName,
      });
      prefs.setString('userPref', userPref);
    } catch (e) {
      throw e;
    }
  }

  Future<void> tryAutoLogin() async {
    Map<String, Object> extractedUserData;
    DateTime expiryDate;

    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userPref')) {
      extractedUserData =
          json.decode(prefs.getString('userPref')) as Map<String, Object>;
      expiryDate = DateTime.parse(extractedUserData['expiryDate']);

      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _userName = extractedUserData['userName'];
      _expiryDate = expiryDate;
      notifyListeners();
      // if (expiryDate.isAfter(DateTime.now())) {
      //   _token = extractedUserData['token'];
      //   _userId = extractedUserData['userId'];
      //   _userName = extractedUserData['userName'];
      //   _expiryDate = expiryDate;
      //   notifyListeners();
      // _autoLogout();
      // }
    }
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    await googleSignIn.signOut();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     // canceling existing timers if available
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
