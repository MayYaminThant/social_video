import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  loggedIn,
}

class AuthStateController extends ChangeNotifier {
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  User? _currentUser;
  User? get currentUser => _currentUser;

  String? _email;
  String? get email => _email;

  String? _errorString;
  String? get errorString => _errorString;

  set loginState(ApplicationLoginState state) {
    if (state == _loginState) {
      return;
    }
    _loginState = state;
    notifyListeners();
  }

  set errorString(String? eStr) {
    if (eStr == _errorString) return;
    _errorString = eStr;
    notifyListeners();
  }

  Future<ApplicationLoginState> init() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _loginState = ApplicationLoginState.loggedIn;
      _currentUser = FirebaseAuth.instance.currentUser;
    } else {
      _loginState = ApplicationLoginState.loggedOut;
      _currentUser = null;
    }

    return _loginState;
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        UserCredential credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _currentUser = credential.user;
        loginState = ApplicationLoginState.loggedIn;
      } else {
        errorString = 'No account with your email. Please register first!';
      }
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> registerAccount(
    String email,
    String displayName,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      loginState = ApplicationLoginState.emailAddress;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
