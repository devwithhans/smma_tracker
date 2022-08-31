import 'dart:async';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/logic/timer/timer_bloc/ticker.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

part 'timer_state.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription? _trackingStream;
  ClientsBloc clientsBloc;

  TrackerRepo trackerRepository;
  String companyId;

  TimerBloc(this.companyId,
      {required Ticker ticker,
      required this.trackerRepository,
      required this.clientsBloc})
      : _ticker = ticker,
        super(TimerInitial()) {
    _checkCurrentTrackings();
    on<TimerStarted>(_onStarted);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<AddDocumentId>(_addDocumentId);
    on<CancelTracking>(_cancelTracker);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Future<void> _checkCurrentTrackings() async {
    TimerEvent? timerEvent = await trackerRepository.checkForRunningTimer();
    if (timerEvent != null) {
      add(timerEvent);
    }
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) async {
    if (state is TimerRunning) {
      showSimpleNotification(
        const Text(
          'You can only track one client at once',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
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
    String? docId;
    if (event.documentId == null) {
      docId = await trackerRepository.beginTracking(
          client: event.client, start: start);
      emit(timerState.copyWith(documentId: docId));
    } else {
      docId = event.documentId;
    }

    if (docId != null) {
      _trackingStream =
          trackerRepository.trackerSubscription(docId).listen((event) {
        if (!event.exists) {
          add(CancelTracking());
        }
      });
    }
  }

  void _cancelTracker(CancelTracking event, Emitter emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial());
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) async {
    // _tickerSubscription!.pause();
    Navigator.pop(navigatorKey.currentContext!);
    TimerRunning timerRunningSnapshot = state as TimerRunning;
    emit(timerRunningSnapshot.copyWith(timerStatus: TimerStatus.loading));
    Duration stopDuration = event.duration;
    DateTime stop = timerRunningSnapshot.start.add(stopDuration);
    clientsBloc.add(OfflineMonthUpdate(
        duration: stopDuration, clientId: timerRunningSnapshot.client.id));
    await trackerRepository.updateTracker(
      stop: stop,
      trackingDocId: timerRunningSnapshot.documentId!,
      duration: event.duration,
      newTag: event.newTag,
    );
    add(CancelTracking());
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    print('tick');
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
