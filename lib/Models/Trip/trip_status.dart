
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

  TripStatus getNext() {
    switch (status) {
      case "created":
        return TripStatus("in progress");
      case "in progress":
        return TripStatus("finished");
      case "finished":
        return TripStatus("created");
      default:
        return TripStatus("created");
    }
  }

}