import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/logic/timer/repositories/ui_helper.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/client_list_result/column_row_clickable.dart';
import 'package:agency_time/utils/widgets/client_list_result/play_button.dart';
import 'package:agency_time/utils/widgets/client_list_result/two_line_text.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:agency_time/views/sheet_client_stats/shared/client_stats_sheet.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

enum DataLevel { user, admin }

class ListResult extends StatelessWidget {
  const ListResult({
    Key? key,
    required this.searchResult,
    required this.moneyFormatter,
    this.dataLevel = DataLevel.admin,
  }) : super(key: key);

  final List<Client> searchResult;
  final NumberFormat moneyFormatter;
  final DataLevel dataLevel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
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
          List<Widget> items = [
            TwoLineText(
                subTitle: moneyFormatter.format(client.selectedMonth!.mrr),
                title: '${client.name}${client.paused ? ' paused' : ''}'),
            TwoLineText(
              title: printDuration(client.selectedMonth!.duration),
              subTitle: client.durationChange.isNegative
                  ? '- ${printDuration(client.durationChange)} / last'
                  : '+ ${printDuration(client.durationChange)} / last',
            ),
            TwoLineText(
              title: moneyFormatter.format(client.selectedMonth!.hourlyRate),
              subTitle: ProcentageChange(
                  small: true,
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
                      FinishTimerUIHelper.onToggleTimer(
                        state: state,
                        context: context,
                        client: client,
                      );
                    })
              ],
            ),
          ];
          if (client.internal) {
            items.removeAt(2);
          }
          return ColumnRowClickable(
            onPressed: () {
              SideSheet.right(
                body: ClientStatsSheet(
                  client: client,
                ),
                context: context,
              );
            },
            items: items,
          );
        }).toList());
      },
    );
  }
}
