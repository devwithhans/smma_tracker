import 'package:agency_time/logic/clients/clients_bloc/clients_bloc.dart';
import 'package:agency_time/logic/data_visualisation/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
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
            Text(title, style: AppTextStyle.boldLarge),
            Text(subText, style: AppTextStyle.medium),
            const SizedBox(height: 20),
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
