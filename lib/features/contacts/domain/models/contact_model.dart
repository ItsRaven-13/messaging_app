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

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      initials: map['initials'] as String,
      phoneNumber: map['phoneNumber'] as String,
      colorIndex: map['colorIndex'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'initials': initials,
      'phoneNumber': phoneNumber,
      'colorIndex': colorIndex,
    };
  }
}
