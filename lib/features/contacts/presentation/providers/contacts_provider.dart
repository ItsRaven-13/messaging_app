import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/features/contacts/data/contact_creation_service.dart';
import 'package:messaging_app/features/contacts/data/contacts_service.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/domain/usecases/create_contact_usecase.dart';

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

class ContactsProvider extends ChangeNotifier {
  final ContactsService _contactsService = ContactsService();
  StreamSubscription<List<ContactModel>>? _subscription;
  StreamSubscription? _hiveSubscription;
  final CreateContactUseCase _createContactUseCase = ContactCreationService();

  List<ContactModel> _contacts = [];
  bool _isLoading = true;
  String? _error;

  List<ContactModel> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ContactsProvider() {
    _listenToContacts();
    _listenToHive();
  }

  void _listenToContacts() {
    _isLoading = true;
    notifyListeners();

    _subscription = _contactsService.contactsStream().listen(
      (contactsData) {
        _contacts = contactsData;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _listenToHive() {
    final box = Hive.box<ContactModel>('contacts');
    _contacts = box.values.toList();

    _hiveSubscription = box.watch().listen((event) async {
      final key = event.key;
      final existedBefore = key != null && _contacts.any((c) => c.uid == key);

      _contacts = box.values.toList();
      notifyListeners();

      if (!event.deleted && key != null && !existedBefore) {
        try {
          await refreshContacts();
        } catch (_) {}
      }
    });
  }

  Future<void> refreshContacts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _subscription?.cancel();
      _listenToContacts();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CreateContactResult> createNewContact({
    required String name,
    required String phone,
  }) async {
    return _createContactUseCase(name: name, phone: phone);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _hiveSubscription?.cancel();
    super.dispose();
  }
}
