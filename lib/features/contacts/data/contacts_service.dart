import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:permission_handler/permission_handler.dart';

extension ChunkingExtension<T> on Iterable<T> {
  Iterable<List<T>> chunked(int size) sync* {
    if (isEmpty) return;
    int i = 0;
    final list = toList();
    while (i < list.length) {
      final end = (i + size < list.length) ? i + size : list.length;
      yield list.sublist(i, end);
      i = end;
    }
  }
}

class ContactsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box<ContactModel> _contactsBox = Hive.box<ContactModel>('contacts');

  Stream<List<ContactModel>> contactsStream() async* {
    yield _contactsBox.values.toList();

    final permission = await Permission.contacts.request();
    if (!permission.isGranted) throw Exception("Permiso de contactos denegado");

    final phoneContacts = await FlutterContacts.getContacts(
      withProperties: true,
    );
    final numbers = phoneContacts
        .map(
          (c) => c.phones.isNotEmpty
              ? _normalizePhone(c.phones.first.number)
              : null,
        )
        .whereType<String>()
        .toSet()
        .toList();

    if (numbers.isEmpty) return;
    const batchSize = 30;
    final List<DocumentSnapshot> allDocs = [];
    final numberChunks = numbers.chunked(batchSize);

    for (final chunk in numberChunks) {
      final query = _firestore
          .collection('users')
          .where('phoneNumber', whereIn: chunk);
      final snapshot = await query.get();
      allDocs.addAll(snapshot.docs);
    }
    await _contactsBox.clear();

    final contacts = allDocs.map((doc) {
      final user = doc.data() as Map<String, dynamic>;
      final contact = ContactModel(
        uid: doc.id,
        name: user['name'] ?? 'Usuario',
        initials: user['initials'] ?? 'U',
        phoneNumber: user['phoneNumber'] ?? '',
        colorIndex: user['colorIndex'] ?? 0,
      );
      _contactsBox.put(contact.uid, contact);
      return contact;
    }).toList();
    yield contacts;
  }

  String _normalizePhone(String number) =>
      number.replaceAll(RegExp(r'[^\d+]'), '').trim();
}
