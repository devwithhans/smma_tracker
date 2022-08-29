import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class OverviewHeader extends StatelessWidget {
  const OverviewHeader({
    required this.subText,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, state) {
            return CustomMonthButton(
              icon: Icons.calendar_month,
              onPressed: () async {
                DateTime? selection = await showMonthPicker(
                  firstDate: context.read<StatsBloc>().state.months.first.date!,
                  lastDate: context.read<StatsBloc>().state.months.last.date!,
                  context: context,
                  initialDate: state.month ?? DateTime.now(),
                );
                if (selection != null) {
                  context.read<StatsBloc>().add(GetStats(month: selection));
                  context
                      .read<ClientsBloc>()
                      .add(GetClientsWithMonth(month: selection));
                }
              },
              text: DateFormat('MMM, y').format(state.month ?? DateTime.now()),
            );
          },
        )
      ],
    );
  }
}
