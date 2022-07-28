import 'dart:async';
import 'package:agency_time/blocs/timer_bloc/ticker.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  TrackerRepository trackerRepository;
  String companyId;

  late StreamSubscription _trackingStream;

  TimerBloc(this.companyId,
      {required Ticker ticker, required this.trackerRepository})
      : _ticker = ticker,
        super(TimerInitial()) {
    on<TimerEvent>(
      (event, emit) {
        print(state);
      },
    );
    on<TimerStarted>(_onStarted);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<AddDocumentId>(_addDocumentId);
    on<CancelTracking>(_cancelTracking);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _cancelTracking(CancelTracking event, Emitter emit) {
    emit(TimerInitial());
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) async {
    if (state is TimerRunning) {
      showSimpleNotification(
        const Text(
          'You can only track one client at once',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        background: Colors.red,
      );
      return;
    }
    DateTime start = event.start ?? DateTime.now();

    emit(
      TimerRunning(
        client: event.client,
        start: start,
        documentId: event.documentId,
        duration: event.duration.inSeconds,
      ),
    );
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker.tick(event.duration.inSeconds).listen(
      (duration) async {
        add(TimerTicked(duration: duration));
      },
    );
    TimerRunning timerState = state as TimerRunning;
    if (timerState.documentId != null) {
      _trackingStream = trackerRepository
          .trackerSubscription(timerState.documentId!)
          .listen((event) {
        print(event);
      });
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) async {
    // _tickerSubscription!.pause();¨
    Navigator.pop(navigatorKey.currentContext!);

    TimerRunning timerRunningSnapshot = state as TimerRunning;
    DateTime stop = timerRunningSnapshot.start.add(event.duration);
    print(stop);
    emit(timerRunningSnapshot.copyWith(timerStatus: TimerStatus.loading));
    await trackerRepository.updateTracker(
      stop: stop,
      trackingDocId: timerRunningSnapshot.documentId!,
      duration: event.duration,
      newTag: event.newTag,
    );
    _tickerSubscription?.cancel();
    emit(TimerInitial());
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    TimerRunning timerRunningSnapshot = state as TimerRunning;
    emit(event.duration > 0
        ? timerRunningSnapshot.copyWith(duration: event.duration)
        : TimerInitial());
  }

  void _addDocumentId(AddDocumentId event, Emitter emit) {
    TimerRunning timerRunningSnapshot = state as TimerRunning;
    emit(timerRunningSnapshot.copyWith(documentId: event.documentId));
  }

  // Future<void> _checkCurrentTrackings() async {
  //   TimerEvent? timerEvent = await trackerRepository.checkForRunningTimer();
  //   if (timerEvent != null) {
  //     add(timerEvent);
  //   }
  // }
}
