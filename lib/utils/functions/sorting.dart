import 'package:agency_time/models/client.dart';

int sortClientByUsersLastActivity(String userId, Client a, Client b) {
  return b.selectedMonth!.employees
      .firstWhere((e) => userId == e.member.id)
      .lastActivity!
      .compareTo(
        a.selectedMonth!.employees
            .firstWhere((e) => userId == e.member.id)
            .lastActivity!,
      );
}
