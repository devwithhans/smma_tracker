import 'dart:async';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/logic/timer/repositories/stopwatch_repo.dart';
import 'package:agency_time/logic/timer/timer_bloc/ticker.dart';
import 'package:agency_time/views/payment_view/paymeny_view_dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:overlay_support/overlay_support.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

class StopWatchBloc extends Bloc<StopWatchEvent, StopWatchState> {
  Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;
  StopWatchRepository stopWatchRepository;

  StopWatchBloc(this.stopWatchRepository) : super(StopWatchState()) {}

  void _startTimer(StartTimer event, Emitter emit) async {
    if (isTimerAlreadyRunning()) return;
    DateTime startTime = DateTime.now();

    emit(state.copyWith(client: event.client, start: startTime));

    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker.tick(0).listen((duration) {
      emit(state.copyWith(duration: duration));
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  bool isTimerAlreadyRunning() {
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
}

Stream<int> tick(int start) {
  return Stream.periodic(const Duration(seconds: 1), (x) => x + 1 + start);
}
