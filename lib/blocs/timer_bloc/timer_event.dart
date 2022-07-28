part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({
    required this.duration,
    required this.client,
    this.documentId,
    this.start,
  });
  final Duration duration;
  final Client client;
  final DateTime? start;
  final String? documentId;
}

class TimerReset extends TimerEvent {
  final Duration duration;
  final Tag newTag;
  const TimerReset({required this.duration, required this.newTag});
}

class AddDocumentId extends TimerEvent {
  const AddDocumentId(this.documentId);
  final String documentId;
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

class CancelTracking extends TimerEvent {}
