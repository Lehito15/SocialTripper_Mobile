
class TripOwnerMasterModel {
  String nickname;
  String profilePictureUrl;

  TripOwnerMasterModel(this.nickname, this.profilePictureUrl);

  factory TripOwnerMasterModel.fromJson(Map<String, dynamic> json) {
    return TripOwnerMasterModel(json['nickname'], json['profilePictureUrl']);
  }
}