import 'package:async/async.dart';
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

    final hiveContacts = _contactsBox.values.map((c) => c.phoneNumber).toList();

    final numbers = {
      ...hiveContacts,
      ...phoneContacts
          .map(
            (c) => c.phones.isNotEmpty
                ? _normalizePhone(c.phones.first.number)
                : null,
          )
          .whereType<String>(),
    }.toList()..sort();

    if (numbers.isEmpty) return;
    const batchSize = 30;
    final chunks = numbers.chunked(batchSize);
    final controllers = <Stream<List<ContactModel>>>[];

    for (final chunk in chunks) {
      final query = _firestore
          .collection('users')
          .where('phoneNumber', whereIn: chunk);

      controllers.add(
        query.snapshots().map((snapshot) {
          final contacts = snapshot.docs.map((doc) {
            final data = doc.data();
            final contact = ContactModel.fromMap({...data, 'uid': doc.id});
            _contactsBox.put(contact.uid, contact);
            return contact;
          }).toList();
          return contacts;
        }),
      );
    }

    yield* StreamGroup.merge(controllers).map((list) {
      final all = _contactsBox.values.toList();
      return all;
    });
  }

  String _normalizePhone(String number) =>
      number.replaceAll(RegExp(r'[^\d+]'), '').trim();
}
