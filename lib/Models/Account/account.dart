import '../User/user.dart';

class Account {
  String uuid;
  String nickname;
  String email;
  bool isPublic;
  String salt;
  String phone;
  String role;
  bool isExpired;
  bool isLocked;
  DateTime createdAt;
  String homePageUrl;
  String description;
  int followsNumber;
  int followingNumber;
  int numberOfTrips;
  String profilePictureUrl;
  UserThumbnail user;


  Account(
      this.uuid,
      this.nickname,
      this.email,
      this.isPublic,
      this.salt,
      this.phone,
      this.role,
      this.isExpired,
      this.isLocked,
      this.createdAt,
      this.homePageUrl,
      this.description,
      this.followsNumber,
      this.followingNumber,
      this.numberOfTrips,
      this.profilePictureUrl,
      this.user);

  factory Account.fromJson(Map<String, dynamic> json) {
    try {
      String uuid = json['uuid'];
      String nickname = json['nickname'];
      String email = json['email'];
      bool isPublic = json['isPublic'];
      String salt = json['salt'];
      String phone = json['phone'];
      String role = json['role'];
      bool isExpired = json['isExpired'];
      bool isLocked = json['isLocked'];
      DateTime createdAt = DateTime.parse(json['createdAt']);
      String homePageUrl = json['homePageUrl'];
      String description = json['description'];
      int followersNumber = json['followersNumber'];
      int followingNumber = json['followingNumber'];
      int numberOfTrips = json['numberOfTrips'];
      String profilePictureUrl = json['profilePictureUrl'];
      UserThumbnail user = UserThumbnail.fromJson(json['user']);
      return Account(
        uuid,
        nickname,
        email,
        isPublic,
        salt,
        phone,
        role,
        isExpired,
        isLocked,
        createdAt,
        homePageUrl,
        description,
        followersNumber,
        followingNumber,
        numberOfTrips,
        profilePictureUrl,
        user,
      );
    } catch (e) {
      print("Error while parsing Account: $e");
      rethrow;
    }
  }


  @override
  String toString() {
    return 'Account{uuid: $uuid, nickname: $nickname, email: $email, isPublic: $isPublic, salt: $salt, phone: $phone, role: $role, isExpired: $isExpired, isLocked: $isLocked, createdAt: $createdAt, homePageUrl: $homePageUrl, description: $description, followsNumber: $followsNumber, followingNumber: $followingNumber, numberOfTrips: $numberOfTrips, profilePictureUrl: $profilePictureUrl, user: $user}';
  }
}
