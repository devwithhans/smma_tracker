import 'dart:async';
import 'package:agency_time/logic/clients/clients_bloc/clients_bloc.dart';

import 'package:agency_time/models/tag.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/logic/timer/repositories/ticker.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/views/dialog_payment/paymeny_view_dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:overlay_support/overlay_support.dart';
part './timer_event.dart';
part './timer_state.dart';

class TimerBloc extends Bloc<StopWatchEvent, TimerState> {
  StreamSubscription<int>? _tickerSubscription;
  ClientsBloc clientsBloc;
  TimerRepository stopWatchRepository;
  StreamSubscription? checkIfFinishedStream;

  Ticker ticker;
  TimerBloc({
    required this.clientsBloc,
    required this.stopWatchRepository,
    required this.ticker,
  }) : super(TimerState()) {
    _checkForExistingTracking();
    on<StartTimer>(_startNewTimer);
    on<StartExistingTimer>(_startExistingTimer);
    on<StopTimer>(_stopTimer);
    on<Ticked>(_ticked);
    on<CancelTracking>(_cancelTracker);
  }

  Future<void> _checkForExistingTracking() async {
    StartExistingTimer? startExistingTimer =
        await stopWatchRepository.checkForRunningTimer();
    if (startExistingTimer != null) {
      add(startExistingTimer);
    }
  }

  void _startNewTimer(StartTimer event, Emitter emit) async {
    if (_isTimerAlreadyRunning()) return;

    DateTime startTime = DateTime.now();

    emit(state.copyWith(
      timerStatus: TimerStatus.running,
      client: event.client,
      startTime: startTime,
    ));
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker.tick(0).listen((duration) async {
      add(Ticked(duration));
    });

    //Creating the tracking in the backend
    String? trackingDocumentId = await stopWatchRepository
        .createTrackingDocumentAndGetId(client: event.client, start: startTime);
    if (trackingDocumentId != null) {
      emit(state.copyWith(trackingDocumentId: trackingDocumentId));
      stopCounterIfDocumentFinished();
    } else {
      _sendTrackingOfflineMessage();
    }
  }

  void _startExistingTimer(StartExistingTimer event, Emitter emit) {
    emit(
      state.copyWith(
        timerStatus: TimerStatus.running,
        client: event.client,
        trackingDocumentId: event.trackingDocumentId,
        startTime: event.startDate,
        duration: event.duration.inSeconds,
      ),
    );
    _tickerSubscription?.cancel();
    _tickerSubscription =
        ticker.tick(event.duration.inSeconds).listen((duration) async {
      add(Ticked(duration));
    });

    if (state.trackingDocumentId != null) {
      stopCounterIfDocumentFinished();
    }
  }

  Future<void> _stopTimer(StopTimer event, Emitter emit) async {
    print('We get it');
    if (state.timerStatus != TimerStatus.running) return;
    emit(state.copyWith(timerStatus: TimerStatus.loading));
    Duration stopDuration = event.duration;
    DateTime stopTime = state.start!.add(stopDuration);

    clientsBloc.add(
        OfflineMonthUpdate(duration: stopDuration, clientId: state.client!.id));

    add(CancelTracking());

    await stopWatchRepository
        .updateTracker(
          stop: stopTime,
          trackingDocId: state.trackingDocumentId!,
          duration: event.duration,
          newTag: event.newTag,
        )
        .catchError((onError) => print(onError));
  }

  void _cancelTracker(CancelTracking event, Emitter emit) {
    _tickerSubscription?.cancel();
    emit(TimerState());
  }

  void _ticked(Ticked event, Emitter emit) {
    emit(
      event.durationAsSeconds > 0
          ? state.copyWith(duration: event.durationAsSeconds)
          : state.copyWith(timerStatus: TimerStatus.loading),
    );
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _sendTrackingOfflineMessage() {
    showSimpleNotification(
      const Text(
        'You can only track one client at once',
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      background: Colors.red,
    );
  }

  bool _isTimerAlreadyRunning() {
    if (state.timerStatus == TimerStatus.running) {
      showSimpleNotification(
        const Text(
          'You can only track one client at once',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
        background: Colors.red,
      );
      return true;
    }
    return false;
  }

  void stopCounterIfDocumentFinished() {
    checkIfFinishedStream = stopWatchRepository
        .trackerDocumentSubscription(state.trackingDocumentId!)
        .listen(
      (event) {
        if (!event.exists || event.data()!['finished']) {
          add(CancelTracking());
        }
      },
    );
  }
}

Stream<int> tick(int start) {
  return Stream.periodic(const Duration(seconds: 1), (x) => x + 1 + start);
}
