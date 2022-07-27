part of 'timer_bloc.dart';

enum TimerStatus { running, initial, stopped, loading }

abstract class TimerState extends Equatable {
  @override
  List get props => [];
}

class TimerInitial extends TimerState {}

class TimerLoading extends TimerState {}

class TimerRunning extends TimerState {
  final Client client;
  final int duration;
  final String? documentId;
  final DateTime start;
  final TimerStatus timerStatus;

  TimerRunning({
    this.timerStatus = TimerStatus.running,
    required this.client,
    this.duration = 0,
    this.documentId,
    required this.start,
  });

  TimerRunning copyWith({
    TimerStatus? timerStatus,
    Client? client,
    int? duration,
    String? documentId,
    DateTime? start,
  }) {
    return TimerRunning(
      timerStatus: timerStatus ?? this.timerStatus,
      client: client ?? this.client,
      start: start ?? this.start,
      documentId: documentId ?? this.documentId,
      duration: duration ?? this.duration,
    );
  }

  @override
  List get props => [duration, client, start, documentId, timerStatus];
}
