part of 'timer_bloc.dart';

enum TimerStatus { running, initial, stopped, loading }

abstract class TimerState extends Equatable {
  @override
  List get props => [];
}

class TimerInitial extends TimerState {}

class TimerLoading extends TimerState {}

class TimerRunning extends TimerState {
  final ClientLite client;
  final int duration;
  final String? documentId;
  final DateTime start;
  final TimerStatus timerStatus;
  final bool loading;
  TimerRunning({
    this.loading = false,
    this.timerStatus = TimerStatus.running,
    required this.client,
    this.duration = 0,
    this.documentId,
    required this.start,
  });

  TimerRunning copyWith({
    bool? loading,
    TimerStatus? timerStatus,
    ClientLite? client,
    int? duration,
    String? documentId,
    DateTime? start,
  }) {
    return TimerRunning(
      loading: loading ?? this.loading,
      timerStatus: timerStatus ?? this.timerStatus,
      client: client ?? this.client,
      start: start ?? this.start,
      documentId: documentId ?? this.documentId,
      duration: duration ?? this.duration,
    );
  }

  @override
  List get props => [duration, client, start, documentId, timerStatus, loading];
}
