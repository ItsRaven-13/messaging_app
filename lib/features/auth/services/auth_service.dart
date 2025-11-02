import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  User? get currentUser => _auth.currentUser;

  Future<void> saveFcmToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fcmToken': FieldValue.arrayUnion([fcmToken]),
      }, SetOptions(merge: true));
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(UserCredential user, String? smsCode)
    verificationCompleted,
    required Function(String error) verificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final userCredential = await _auth.signInWithCredential(credential);
          verificationCompleted(userCredential, credential.smsCode);
        } catch (e) {
          verificationFailed(e.toString());
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationFailed(e.message ?? "Error desconocido");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<UserCredential> signInWithSmsCode(String smsCode) async {
    if (_verificationId == null) {
      throw Exception("No se encontró verificationId");
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmTokens': FieldValue.arrayRemove([fcmToken]),
        });
      }
    }

    await FirebaseMessaging.instance.deleteToken();
    await _auth.signOut();
  }
}
