import 'package:flutter/material.dart';
import 'package:messaging_app/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _loading = false;
  String? _verificationId;
  User? _user;

  AuthProvider() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get loading => _loading;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> sendCode({
    required String phoneNumber,
    required Function() onCodeSent,
    required Function(User, String? smsCode) onVerified,
    required Function(String) onError,
  }) async {
    _setLoading(true);
    await _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId) {
        _verificationId = verificationId;
        _setLoading(false);
        onCodeSent();
      },
      verificationCompleted: (userCredential, smsCode) {
        _user = userCredential.user;
        _setLoading(false);
        onVerified(userCredential.user!, smsCode);
      },
      verificationFailed: (error) {
        _setLoading(false);
        onError(error);
      },
    );
  }

  Future<void> verifyCode({
    required String smsCode,
    required Function(User) onSuccess,
    required Function(String) onError,
  }) async {
    if (_verificationId == null) {
      onError("No se encontró verificationId");
      return;
    }
    _setLoading(true);
    try {
      final userCredential = await _authService.signInWithSmsCode(smsCode);
      _user = userCredential.user;
      _setLoading(false);
      onSuccess(userCredential.user!);
    } catch (e) {
      _setLoading(false);
      onError(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
