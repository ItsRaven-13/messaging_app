import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<ContactModel?> fetchUserAsContact(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()!;

      final String fallbackName = data['phoneNumber'] ?? userId;
      final String tempInitials = '??';

      return ContactModel.fromMap({
        ...data,
        'name': fallbackName,
        'initials': tempInitials,
      });
    } catch (e) {
      print('Error al buscar usuario $userId en Firebase: $e');
      return null;
    }
  }
}
