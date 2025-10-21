import 'dart:async';
import 'package:flutter/material.dart';
import 'package:messaging_app/features/contacts/data/contacts_service.dart';
import 'package:messaging_app/features/contacts/domain/contact_model.dart';

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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
