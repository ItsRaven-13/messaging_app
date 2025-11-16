import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/domain/usecases/create_contact_usecase.dart';

class ContactCreationService implements CreateContactUseCase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<ContactModel> _contactsBox = Hive.box<ContactModel>('contacts');

  @override
  Future<CreateContactResult> call({
    required String name,
    required String phone,
  }) async {
    final newContact = Contact()
      ..name.first = name
      ..phones = [Phone(phone)];

    await newContact.insert();

    final normalizedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '').trim();

    final query = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final contact = ContactModel.fromMap({...doc.data(), 'uid': doc.id});

      _contactsBox.put(contact.uid, contact);

      return CreateContactResult(existsInApp: true, contactModel: contact);
    }

    return CreateContactResult(existsInApp: false, contactModel: null);
  }
}
