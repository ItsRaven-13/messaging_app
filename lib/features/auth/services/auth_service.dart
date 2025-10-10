import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  User? get currentUser => _auth.currentUser;

  /// Verifica número de teléfono y envía código
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
    await _auth.signOut();
  }
}
