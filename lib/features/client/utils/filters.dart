import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/models/client.dart';

class ClientSorts {
  ClientSorts(this.userId);
  final String userId;

  Map<String, Function(Client, Client)> getClientFilters() {
    return {
      'Last updated': lastUpdated,
      'MRR': mrr,
    };
  }

  int lastUpdated(Client a, Client b) {
    return b.selectedMonth!.employees
        .firstWhere((e) => userId == e.member.id)
        .lastActivity!
        .compareTo(
          a.selectedMonth!.employees
              .firstWhere((e) => userId == e.member.id)
              .lastActivity!,
        );
  }

  int mrr(Client a, Client b) {
    return b.selectedMonth!.mrr.compareTo(a.selectedMonth!.mrr);
  }
}
