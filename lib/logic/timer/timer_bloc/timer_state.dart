part of 'timer_bloc.dart';

enum TimerStatus { running, initial, paused, loading }

class TimerState extends Equatable {
  final Client? client;
  final TimerStatus timerStatus;
  final int duration;
  final String? trackingDocumentId;
  final DateTime? start;
  TimerState({
    this.timerStatus = TimerStatus.initial,
    this.client,
    this.duration = 0,
    this.trackingDocumentId,
    this.start,
  });

  TimerState copyWith({
    Client? client,
    TimerStatus? timerStatus,
    int? duration,
    String? trackingDocumentId,
    DateTime? startTime,
  }) {
    return TimerState(
      client: client ?? this.client,
      timerStatus: timerStatus ?? this.timerStatus,
      duration: duration ?? this.duration,
      trackingDocumentId: trackingDocumentId ?? this.trackingDocumentId,
      start: startTime ?? this.start,
    );
  }

  @override
  List get props => [duration, timerStatus, client, trackingDocumentId, start];
}
