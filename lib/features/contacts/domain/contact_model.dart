import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 1)
class ContactModel {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String initials;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final int colorIndex;

  ContactModel({
    required this.uid,
    required this.name,
    required this.initials,
    required this.phoneNumber,
    required this.colorIndex,
  });
}
