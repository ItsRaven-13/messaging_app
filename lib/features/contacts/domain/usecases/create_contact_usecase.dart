import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';

abstract class CreateContactUseCase {
  Future<CreateContactResult> call({
    required String name,
    required String phone,
  });
}

class CreateContactResult {
  final bool existsInApp;
  final ContactModel? contactModel;

  CreateContactResult({required this.existsInApp, this.contactModel});
}
