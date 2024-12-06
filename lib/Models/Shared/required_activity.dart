import 'package:social_tripper_mobile/Models/Shared/activity.dart';

class RequiredActivity {
  double requiredExperience;
  Activity activity;

  RequiredActivity(this.requiredExperience, this.activity);

  factory RequiredActivity.fromJson(Map<String, dynamic> json) {
    return RequiredActivity(
      json['requiredExperience'],
      Activity.fromJson(json['activity'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requiredExperience': requiredExperience,
      'activity': activity.toJson()
    };
  }

}