import 'package:agency_time/models/tag.dart';

class Tracking {
  final String id;
  final String clientId;
  final String clientName;
  final Duration duration;
  final DateTime start;
  final DateTime stop;
  final String userId;
  final Tag tag;
  final String userName;

  Tracking({
    required this.id,
    required this.tag,
    required this.clientId,
    required this.clientName,
    required this.duration,
    required this.start,
    required this.stop,
    required this.userId,
    required this.userName,
  });
}
