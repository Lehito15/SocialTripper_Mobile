class UserTripRequest {
  String userUUID;
  String eventUUID;
  String message;

  UserTripRequest(this.userUUID, this.eventUUID, this.message);

  factory UserTripRequest.fromJson(Map<String, dynamic> json) {
    return UserTripRequest(
      json['userUUID'],
      json['eventUUID'],
      json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userUUID': userUUID,
      'eventUUID': eventUUID,
      'message': message
    };
  }
}
