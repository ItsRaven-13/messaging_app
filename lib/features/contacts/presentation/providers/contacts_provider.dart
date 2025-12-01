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

  List<ContactModel> _allContacts = [];
  String _searchQuery = '';

  bool _isLoading = true;
  String? _error;
  bool _initialized = false;

  List<ContactModel> get contacts {
    if (_searchQuery.isEmpty) {
      return _allContacts;
    }
    final searchLower = _searchQuery.toLowerCase();
    return _allContacts.where((contact) {
      final nameLower = contact.name.toLowerCase();
      final phoneLower = contact.phoneNumber.toLowerCase();
      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower);
    }).toList();
  }

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get initialized => _initialized;

  ContactsProvider() {
    _listenToHive();
  }

  Future<void> initialize(String myId) async {
    if (_initialized) return;
    _listenToContacts(myId);
    _initialized = true;
    notifyListeners();
  }

  void _listenToContacts(String myId) {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _contactsService
        .contactsStream(myId)
        .listen(
          (contactsData) {
            _allContacts = contactsData;
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void _listenToHive() {
    final box = Hive.box<ContactModel>('contacts');
    _allContacts = box.values.toList();

    _hiveSubscription = box.watch().listen((event) async {
      _allContacts = box.values.toList();
      notifyListeners();
    });
  }

  Future<void> cancelAllListeners() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
    _allContacts = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
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
