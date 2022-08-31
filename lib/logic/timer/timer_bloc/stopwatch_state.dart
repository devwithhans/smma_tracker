part of 'stopwatch_bloc.dart';

enum TimerStatus { running, initial, pused }

class StopWatchState extends Equatable {
  final Client? client;
  final TimerStatus timerStatus;
  final int duration;
  final String? trackingDocumentId;
  final DateTime? start;
  StopWatchState({
    this.timerStatus = TimerStatus.running,
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
    DateTime? start,
  }) {
    return StopWatchState(
      client: client ?? this.client,
      timerStatus: timerStatus ?? this.timerStatus,
      duration: duration ?? this.duration,
      trackingDocumentId: trackingDocumentId ?? this.trackingDocumentId,
      start: start ?? this.start,
    );
  }

  @override
  List get props => [];
}
