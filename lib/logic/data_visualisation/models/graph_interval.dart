class GraphInterval {
  DateTime start;
  DateTime end;

  GraphInterval({
    required this.start,
    required this.end,
  });

  static GraphInterval last7Days = GraphInterval(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  static GraphInterval last4Weeks = GraphInterval(
    start: DateTime.now().subtract(const Duration(days: 28)),
    end: DateTime.now(),
  );

  static GraphInterval monthToDate = GraphInterval(
    start: DateTime.utc(DateTime.now().year, DateTime.now().month, 0),
    end: DateTime.now(),
  );
  static GraphInterval yearToDate = GraphInterval(
    start: DateTime.utc(DateTime.now().year, 1, 1),
    end: DateTime.now(),
  );
}
