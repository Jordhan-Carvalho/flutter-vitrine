import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth with ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final fbLogin = new FacebookLogin();

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String _userName;
  String _provider;
  bool _userAdmin;

  // String get token
  bool isAuthenti;

// right one
  // bool get isAuth {
  //   return token != null;
  // }
  bool get isAuth {
    return _userId != null;
  }

  bool get isAdmin {
    return _userAdmin;
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
      final DocumentSnapshot userRole = await _firestore
          .collection('administrators')
          .document(currentUser.uid)
          .get();

      _userAdmin = userRole.exists;
      print('user admin $_userAdmin');

      _userName = user.displayName;
      _token = userData.token;
      _userId = currentUser.uid;
      _expiryDate = userData.expirationTime;
      _provider = 'google';

      // _autoLogout();
      notifyListeners();

      //store persistent data on phone
      final prefs = await SharedPreferences.getInstance();
      final userPref = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'userName': _userName,
        'provider': _provider,
        'userAdmin': _userAdmin,
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
      _provider = extractedUserData['provider'];
      _userAdmin = extractedUserData['userAdmin'];
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
    Map<String, Object> extractedUserData;

    _token = null;
    _userId = null;
    _expiryDate = null;
    _userAdmin = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userPref')) {
      extractedUserData =
          json.decode(prefs.getString('userPref')) as Map<String, Object>;

      _provider = extractedUserData['provider'];
      if (_provider == 'google') {
        await googleSignIn.signOut();
      } else {
        await fbLogin.logOut();
      }
      _provider = null;
    }
    notifyListeners();
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

  Future<void> signInWithFacebook() async {
    FirebaseUser currentUser;
    try {
      final FacebookLoginResult result =
          await fbLogin.logIn(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          final AuthResult authResult =
              await _auth.signInWithCredential(credential);
          final FirebaseUser user = authResult.user;
          print(user.displayName);

          assert(user.displayName != null);
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          currentUser = await _auth.currentUser();
          assert(user.uid == currentUser.uid);

          final DocumentSnapshot userRole = await _firestore
              .collection('administrators')
              .document(currentUser.uid)
              .get();

          _userAdmin = userRole.exists;

          _userName = user.displayName;
          _token = result.accessToken.token;
          _userId = currentUser.uid;
          _expiryDate = result.accessToken.expires;
          _provider = 'facebook';

          notifyListeners();

          final prefs = await SharedPreferences.getInstance();
          final userPref = json.encode({
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
            'userName': _userName,
            'provider': _provider,
            'userAdmin': _userAdmin,
          });
          prefs.setString('userPref', userPref);

          break;
        case FacebookLoginStatus.cancelledByUser:
          print('canceled');
          break;
        case FacebookLoginStatus.error:
          print('Switch error');
          print(result.errorMessage);
          fbLogin.logOut();
          break;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
