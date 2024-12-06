class TripMultimedia {
  String multimediaUrl;
  double latitude;
  double longitude;
  DateTime timestamp;
  String userUUID;
  String eventUUID;

  TripMultimedia(this.multimediaUrl, this.latitude, this.longitude,
      this.timestamp, this.userUUID, this.eventUUID);

  factory TripMultimedia.fromJson(Map<String, dynamic> json) {
    return TripMultimedia(
      json['multimediaUrl'],
      json['latitude'],
      json['longitude'],
      json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      json['userUUID'],
      json['eventUUID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'multimediaUrl': multimediaUrl,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(), // Konwertowanie DateTime na String
      'userUUID': userUUID,
      'eventUUID': eventUUID,
    };
  }
}
