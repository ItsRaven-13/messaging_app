class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String profilePictureUrl;
  final DateTime lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.lastSeen,
  });
}
