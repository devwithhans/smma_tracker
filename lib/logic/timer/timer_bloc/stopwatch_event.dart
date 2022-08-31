part of 'stopwatch_bloc.dart';

abstract class StopWatchEvent extends Equatable {
  const StopWatchEvent();

  @override
  List<Object> get props => [];
}

class StartExistingTimer extends StopWatchEvent {
  Client client;
  Duration duration;
  DateTime startDate;
  String trackingDocumentId;

  StartExistingTimer({
    required this.client,
    required this.duration,
    required this.startDate,
    required this.trackingDocumentId,
  });
}

class StartTimer extends StopWatchEvent {
  Client client;
  StartTimer({
    required this.client,
  });
}

class StopTimer extends StopWatchEvent {}
