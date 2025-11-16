import 'package:flutter/material.dart';
import 'package:messaging_app/features/auth/domain/models/user_model.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';

class UserProfileProvider extends ChangeNotifier {
  final AuthProvider auth;

  UserModel? user;
  bool loading = true;

  String editedName = '';
  String editedInfo = '';
  int selectedColorIndex = 0;

  UserProfileProvider(this.auth);

  Future<void> loadUser() async {
    loading = true;
    notifyListeners();

    user = await auth.getLocalUserProfile();

    if (user != null) {
      editedName = user!.name ?? '';
      editedInfo = user!.info ?? '';
      selectedColorIndex = user!.colorIndex ?? 0;
    }

    loading = false;
    notifyListeners();
  }

  void updateName(String name) {
    editedName = name;
    notifyListeners();
  }

  void updateInfo(String info) {
    editedInfo = info;
    notifyListeners();
  }

  void updateColorIndex(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  Future<void> saveChanges() async {
    await auth.saveUserProfile(
      name: editedName,
      info: editedInfo,
      colorIndex: selectedColorIndex,
    );
    await loadUser();
  }
}
