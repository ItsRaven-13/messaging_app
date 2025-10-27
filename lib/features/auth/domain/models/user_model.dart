class UserModel {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? initials;
  final int? colorIndex;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.initials,
    this.colorIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'initials': initials,
      'colorIndex': colorIndex,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
      initials: map['initials'],
      colorIndex: map['colorIndex'],
    );
  }
}
