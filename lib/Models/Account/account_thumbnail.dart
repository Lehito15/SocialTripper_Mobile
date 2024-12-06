
import 'package:social_tripper_mobile/Models/User/user.dart';

class AccountThumbnail {
  String uuid;
  String nickname;
  String homePageUrl;
  String description;
  int followersNumber;
  int followingNumber;
  int numberOfTrips;
  bool isPublic;
  String profilePictureUrl;
  UserThumbnail user;

  AccountThumbnail(
      this.uuid,
      this.nickname,
      this.homePageUrl,
      this.description,
      this.followersNumber,
      this.followingNumber,
      this.numberOfTrips,
      this.isPublic,
      this.profilePictureUrl,
      this.user);

  factory AccountThumbnail.fromJson(Map<String, dynamic> json) {
    try {
      String uuid = json['uuid'];
      String nickname = json['nickname'];
      bool isPublic = json['isPublic'];
      String homePageUrl = json['homePageUrl'];
      String description = json['description'];
      int followersNumber = json['followersNumber'];
      int followingNumber = json['followingNumber'];
      int numberOfTrips = json['numberOfTrips'];
      String profilePictureUrl = json['profilePictureUrl'];
      UserThumbnail user = UserThumbnail.fromJson(json['user']);
      return AccountThumbnail(
        uuid,
        nickname,
        homePageUrl,
        description,
        followersNumber,
        followingNumber,
        numberOfTrips,
        isPublic,
        profilePictureUrl,
        user
      );
    } catch (e) {
      print("Error while parsing Account: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'nickname': nickname,
      'homePageUrl': homePageUrl,
      'description': description,
      'followersNumber': followersNumber,
      'followingNumber': followingNumber,
      'numberOfTrips': numberOfTrips,
      'isPublic': isPublic,
      'profilePictureUrl': profilePictureUrl,
      'user': user.toJson(),  // Zakładając, że masz metodę toJson w klasie UserThumbnail
    };
  }
}