import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/features/auth/domain/models/user_model.dart';
import 'package:messaging_app/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';

class AuthProvider extends ChangeNotifier {
  final ChatProvider chatProvider;
  final ContactsProvider contactsProvider;
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false;
  String? _verificationId;
  User? _user;

  AuthProvider({required this.chatProvider, required this.contactsProvider}) {
    _firestore.settings = const Settings(persistenceEnabled: true);

    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
      _syncProfileOnLogin();
    });
  }

  bool get loading => _loading;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> saveUserProfileLocal(UserModel user) async {
    final box = Hive.box('user_profile');
    await box.put('current_user', user.toMap());
  }

  Future<UserModel?> getLocalUserProfile() async {
    final box = Hive.box('user_profile');
    final map = box.get('current_user');
    if (map == null) return null;
    return UserModel.fromMap(Map<String, dynamic>.from(map));
  }

  Future<bool> isProfileCompleteLocal() async {
    final user = await getLocalUserProfile();
    return user != null && user.name != null && user.name!.isNotEmpty;
  }

  Future<void> syncProfileWithFirebase() async {
    final user = await getLocalUserProfile();
    if (user == null || _user == null) return;

    try {
      await _firestore.collection('users').doc(_user!.uid).set(user.toMap());
      await _authService.saveFcmToken();
    } catch (e) {
      debugPrint('Error sincronizando perfil: $e');
    }
  }

  Future<bool> synchronizeProfile() async {
    bool isLocalComplete = await isProfileCompleteLocal();
    if (isLocalComplete) {
      return true;
    }
    return await loadProfileFromFirebaseAndSaveLocal();
  }

  void _syncProfileOnLogin() async {
    if (await isProfileCompleteLocal()) {
      await syncProfileWithFirebase();
    }
  }

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
      await synchronizeProfile();
      _setLoading(false);
      onSuccess(userCredential.user!);
    } catch (e) {
      _setLoading(false);
      onError(e.toString());
    }
  }

  Future<void> signOut() async {
    await chatProvider.cancelAllListeners();
    await contactsProvider.cancelAllListeners();
    _user = null;
    notifyListeners();
    try {
      await _authService.signOut();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
    }
    await _clearLocalData();
  }

  Future<void> _clearLocalData() async {
    try {
      final userBox = Hive.box('user_profile');
      await userBox.clear();
      final contactsBox = Hive.box<ContactModel>('contacts');
      await contactsBox.clear();
      final messagesBox = Hive.box<MessageModel>('messages');
      await messagesBox.clear();

      debugPrint('Datos locales de Hive limpiados.');
    } catch (e) {
      debugPrint('Error limpiando datos locales: $e');
    }
  }

  Future<void> saveUserProfile({
    required String name,
    required String info,
    required int colorIndex,
  }) async {
    if (_user == null) return;

    final initials = _getInitials(name);
    final newUser = UserModel(
      uid: _user!.uid,
      phoneNumber: _user!.phoneNumber ?? '',
      name: name,
      info: info,
      initials: initials,
      colorIndex: colorIndex,
    );

    await saveUserProfileLocal(newUser);
    try {
      syncProfileWithFirebase();
    } catch (e) {
      debugPrint("Error intentando sincronizar perfil: $e");
    }
  }

  Future<bool> loadProfileFromFirebaseAndSaveLocal() async {
    if (_user == null) return false;
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final userModel = UserModel.fromMap(docSnapshot.data()!);
        await saveUserProfileLocal(userModel);
        return true;
      }
    } catch (e) {
      debugPrint('Error al cargar perfil desde Firebase: $e');
    }
    return false;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
