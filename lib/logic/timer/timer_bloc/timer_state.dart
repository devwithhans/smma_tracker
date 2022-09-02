part of 'timer_bloc.dart';

enum TimerStatus { running, initial, paused, loading }

class StopWatchState extends Equatable {
  final Client? client;
  final TimerStatus timerStatus;
  final int duration;
  final String? trackingDocumentId;
  final DateTime? start;
  StopWatchState({
    this.timerStatus = TimerStatus.initial,
    this.client,
    this.duration = 0,
    this.trackingDocumentId,
    this.start,
  });

  StopWatchState copyWith({
    Client? client,
    TimerStatus? timerStatus,
    int? duration,
    String? trackingDocumentId,
    DateTime? startTime,
  }) {
    return StopWatchState(
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
