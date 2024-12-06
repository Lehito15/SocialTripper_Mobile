
class TripStatus {
  String status;

  TripStatus(this.status);

  factory TripStatus.fromJson(Map<String, dynamic> json) {
    return TripStatus(
      json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status
    };
  }

}