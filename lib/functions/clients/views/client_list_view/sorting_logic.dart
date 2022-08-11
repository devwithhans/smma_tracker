import 'package:agency_time/functions/clients/models/client.dart';

Map<String, Map<bool, int Function(Client, Client)?>> filters = {
  'Latest': {
    true: sortOnLatest,
    false: sortOnLatest,
  },
  'Name': {
    true: sortAlphabetical,
    false: inversSortAlphabetical,
  },
  'MRR': {
    true: inversSortOnMrr,
    false: sortOnMrr,
  },
  'Hourly Rate': {
    true: sortOnHourlyRate,
    false: inversSortOnHourlyRate,
  },
};

int sortAlphabetical(Client a, Client b) {
  var aName = a.name.toLowerCase();
  var bName = b.name.toLowerCase();
  return aName.compareTo(bName);
}

int inversSortAlphabetical(Client a, Client b) {
  var aName = a.name.toLowerCase();
  var bName = b.name.toLowerCase();
  return bName.compareTo(aName);
}

int sortOnHourlyRate(Client a, Client b) {
  double houryRateA = a.selectedMonth.mrr / (a.selectedMonth.duration.inHours);
  double houryRateB = b.selectedMonth.mrr / (b.selectedMonth.duration.inHours);
  if (houryRateA < houryRateB) {
    return -1;
  } else if (houryRateA > houryRateB) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnHourlyRate(Client a, Client b) {
  double houryRateA = a.selectedMonth.mrr / (a.selectedMonth.duration.inHours);
  double houryRateB = b.selectedMonth.mrr / (b.selectedMonth.duration.inHours);
  if (houryRateA > houryRateB) {
    return -1;
  } else if (houryRateA < houryRateB) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnMrr(a, b) {
  if (a.selectedMonth!.mrr > b.selectedMonth!.mrr) {
    return -1;
  } else if (a.selectedMonth!.mrr < b.selectedMonth!.mrr) {
    return 1;
  } else {
    return 0;
  }
}

int sortOnMrr(a, b) {
  if (a.selectedMonth!.mrr < b.selectedMonth!.mrr) {
    return -1;
  } else if (a.selectedMonth!.mrr > b.selectedMonth!.mrr) {
    return 1;
  } else {
    return 0;
  }
}

int sortOnLatest(Client a, Client b) {
  if (a.updatedAt == null && b.updatedAt == null) {
    return 0;
  } else if (a.updatedAt == null) {
    return 1;
  } else if (b.updatedAt == null) {
    return -1;
  } else {
    return b.updatedAt!.compareTo(a.updatedAt!);
  }
}

int sortOnChange(Client a, Client b) {
  double aChange = ((a.selectedMonth.duration.inSeconds -
          a.compareMonth!.duration.inSeconds) /
      a.selectedMonth.duration.inSeconds *
      100);
  double bChange = ((b.selectedMonth.duration.inSeconds -
          b.compareMonth!.duration.inSeconds) /
      b.selectedMonth.duration.inSeconds *
      100);

  aChange = aChange.isInfinite || aChange.isNaN ? -10000 : aChange;
  bChange = bChange.isInfinite || bChange.isNaN ? -10000 : bChange;

  if (aChange > bChange) {
    return -1;
  } else if (aChange < bChange) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnChange(Client a, Client b) {
  double aChange = ((a.selectedMonth.duration.inSeconds -
          a.compareMonth!.duration.inSeconds) /
      a.selectedMonth.duration.inSeconds *
      100);
  double bChange = ((b.selectedMonth.duration.inSeconds -
          b.compareMonth!.duration.inSeconds) /
      b.selectedMonth.duration.inSeconds *
      100);

  aChange = aChange.isInfinite || aChange.isNaN ? -10000 : aChange;
  bChange = bChange.isInfinite || bChange.isNaN ? -10000 : bChange;

  if (aChange < bChange) {
    return -1;
  } else if (aChange > bChange) {
    return 1;
  } else {
    return 0;
  }
}
