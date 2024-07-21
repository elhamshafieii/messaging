class UserModel {
  final String name;
  final String about;
  final String uid;
  final String? profilePic;
  final String phoneNumber;
  final bool isOnline;

  UserModel(
      {required this.about,
      required this.name,
      required this.uid,
      required this.profilePic,
      required this.phoneNumber,
      required this.isOnline});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'about': about,
      'uid': uid,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      about: map['about'] ?? 'Hey there, I am using Messaging',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
