part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object> get props => [];
}

class AddMonth extends StatsEvent {
  final QueryDocumentSnapshot<Map<String, dynamic>> monthDoc;
  const AddMonth(this.monthDoc);
}

class GetStats extends StatsEvent {
  final DateTime? month;
  const GetStats({this.month});
}
