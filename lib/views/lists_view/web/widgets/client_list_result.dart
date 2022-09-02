import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/finish_tracking_view.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:agency_time/views/lists_view/web/widgets/column_row_clickable.dart';
import 'package:agency_time/views/lists_view/web/widgets/play_button.dart';
import 'package:agency_time/views/lists_view/web/widgets/two_line_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

class ClientListResult extends StatelessWidget {
  const ClientListResult({
    Key? key,
    required this.searchResult,
    required this.moneyFormatter,
  }) : super(key: key);

  final List<Client> searchResult;
  final NumberFormat moneyFormatter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, StopWatchState>(
      builder: (context, state) {
        bool isTracking;
        bool isLoading;
        return Column(
            children: searchResult.map((Client client) {
          if (state.client != null && state.client!.id == client.id) {
            isLoading = state.timerStatus == TimerStatus.loading;
            isTracking = true;
          } else {
            isLoading = false;
            isTracking = false;
          }

          if (isLoading) {
            return Container(
              height: 90,
              color: Colors.black,
            );
          }
          return ColumnRowClickable(
            onPressed: () {},
            items: [
              TwoLineText(
                  subTitle: moneyFormatter.format(client.selectedMonth!.mrr),
                  title: client.name),
              TwoLineText(
                title: printDuration(client.selectedMonth!.duration),
                subTitle: client.durationChange.isNegative
                    ? '- ${printDuration(client.durationChange)} / last'
                    : '+ ${printDuration(client.durationChange)} / last',
              ),
              TwoLineText(
                title: moneyFormatter.format(client.selectedMonth!.hourlyRate),
                subTitle: ProcentageChange(
                    procentage: client.hourlyRateChange.isFinite
                        ? client.hourlyRateChange
                        : 100),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEE, dd MMM HH:MM ')
                        .format(client.selectedMonth!.updatedAt),
                    style: AppTextStyle.medium,
                  ),
                  PlayButton(
                    isTracking: isTracking,
                    onPressed: () {
                      if (state.timerStatus == TimerStatus.running) {
                        SideSheet.right(
                          width: 500,
                          body: FinishTrackingDialog(
                            onDelete: () {
                              context
                                  .read<TimerRepository>()
                                  .deleteTracking(state.trackingDocumentId!);
                            },
                            onSave: (Tag? newTag, Duration duration) {
                              context.read<TimerBloc>().add(
                                    StopTimer(
                                        duration: duration, newTag: newTag),
                                  );
                            },
                            client: state.client!,
                            duration: Duration(seconds: state.duration),
                            tags: context.read<ClientsRepo>().getTags(),
                          ),
                          context: context,
                        );
                      } else {
                        context
                            .read<TimerBloc>()
                            .add(StartTimer(client: client));
                      }
                    },
                  )
                ],
              ),
            ],
          );
        }).toList());
      },
    );
  }
}
