import 'package:latlong2/latlong.dart';

import '../../Services/relation_service.dart';

class UserPathPoints {
  final String userUUID;
  final String eventUUID;
  final List<PointDTO> pathPoints;

  UserPathPoints({required this.userUUID, required this.eventUUID, required this.pathPoints});

  // Zamiana na JSON
  Map<String, dynamic> toJson() {
    return {
      'userUUID': userUUID,
      'eventUUID': eventUUID,
      'pathPoints': pathPoints.map((point) => point.toJson()).toList(),
    };
  }

  // Deserializacja z JSON
  factory UserPathPoints.fromJson(Map<String, dynamic> json) {
    var pathPointsFromJson = (json['pathPoints'] as List)
        .map((pointJson) => PointDTO.fromJson(pointJson)) // Zakładając, że PointDTO ma metodę fromJson
        .toList();
    print(pathPointsFromJson);
    return UserPathPoints(
      userUUID: json['userUUID'],
      eventUUID: json['eventUUID'],
      pathPoints: pathPointsFromJson,
    );
  }

  @override
  String toString() {
    return 'UserPathPoints{userUUID: $userUUID, eventUUID: $eventUUID, pathPoints: $pathPoints}';
  }
}