import 'dart:js';

import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/views/data_visualisation_views/data_visualisation_dependencies.dart';
import 'package:agency_time/views/finish_tracker_sheet/shared/finish_timer_view.dart';
import 'package:side_sheet/side_sheet.dart';

class FinishTimerUIHelper {
  static onToggleTimer({
    required TimerState state,
    required BuildContext context,
    required Client client,
  }) {
    if (state.timerStatus == TimerStatus.running) {
      SideSheet.right(
        width: 500,
        body: FinishTimerView(
          onDelete: () async {
            await context
                .read<TimerRepository>()
                .deleteTracking(state.trackingDocumentId!);
            // Navigator.pop(context);
          },
          onSave: (Tag? newTag, Duration duration) async {
            context.read<TimerBloc>().add(
                  StopTimer(duration: duration, newTag: newTag),
                );
            Navigator.pop(context);
          },
          client: state.client!,
          duration: Duration(seconds: state.duration),
          tags: context.read<ClientsRepo>().getTags(),
        ),
        context: context,
      );
    } else {
      context.read<TimerBloc>().add(StartTimer(client: client));
    }
  }
}
