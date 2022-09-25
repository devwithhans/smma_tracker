part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class RunStream extends DataEvent {}

class GetMonths extends DataEvent {}

class SetCompareMonth extends DataEvent {
  DateTime? monthDate;
  SetCompareMonth({this.monthDate});
}
