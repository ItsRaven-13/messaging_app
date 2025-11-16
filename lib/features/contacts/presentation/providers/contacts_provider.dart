import 'dart:async';
import 'package:flutter/material.dart';
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
  final CreateContactUseCase _createContactUseCase = ContactCreationService();

  List<ContactModel> _contacts = [];
  bool _isLoading = true;
  String? _error;

  List<ContactModel> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ContactsProvider() {
    _listenToContacts();
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
    super.dispose();
  }
}
