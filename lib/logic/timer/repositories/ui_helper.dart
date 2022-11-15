import 'dart:js';

import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/features/client/repository/client_repo.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/logic/clients/repos/client_repo.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:agency_time/views/sheet_finish_tracker/shared/finish_timer_view.dart';
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
          tags: context.read<NewClientRepo>().getTags(),
        ),
        context: context,
      );
    } else {
      context.read<TimerBloc>().add(StartTimer(client: client));
    }
  }
}
