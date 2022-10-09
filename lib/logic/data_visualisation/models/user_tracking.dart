import 'package:agency_time/models/user.dart';
import 'package:agency_time/logic/data_visualisation/models/duration_data.dart';

class UserTracking {
  DurationData durationData;
  String userId;
  Map tags;
  DateTime updatedAt;

  UserTracking({
    required this.userId,
    required this.durationData,
    required this.updatedAt,
    this.tags = const {},
  });
  static List<UserTracking> toList(Map<String, dynamic>? userMap) {
    List<UserTracking> userTrackings = [];

    if (userMap != null) {
      userMap.forEach((key, value) {
        UserTracking user = UserTracking.fromMap(value, key);
      });
    }
    return userTrackings;
  }

  static UserTracking fromMap(Map<String, dynamic> value, String userId) {
    return UserTracking(
      userId: userId,
      durationData: DurationData.fromMap(value: value),
      updatedAt: value['updatedAt'].toDate(),
      tags: value['tags'],
    );
  }
}
