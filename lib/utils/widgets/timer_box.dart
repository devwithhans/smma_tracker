import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/finish_tracking_view.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerBox extends StatelessWidget {
  const TimerBox({
    Key? key,
    required this.timerState,
  }) : super(key: key);

  final TimerRunning timerState;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timerState.client.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                printDuration(Duration(seconds: timerState.duration)),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet<void>(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext con) {
                  if (timerState.timerStatus == TimerStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return FinishTrackingDialog(
                    onDelete: () {
                      context.read<TrackerRepo>().deleteTracking(
                          trackingDocId: timerState.documentId!);
                    },
                    onSave: (Tag? newTag, Duration duration) {
                      context.read<TimerBloc>().add(
                            TimerReset(duration: duration, newTag: newTag),
                          );
                    },
                    client: timerState.client,
                    duration: Duration(seconds: timerState.duration),
                    tags: context.read<ClientsRepo>().getTags(),
                  );
                },
              );
            },
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.stop_rounded,
                color: Colors.white,
              ),
            ),
            iconSize: 40,
          )
        ],
      ),
    );
  }
}
