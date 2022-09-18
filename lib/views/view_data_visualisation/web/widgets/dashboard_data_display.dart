import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/dashdata.dart';

import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/logic/clients/clients_bloc/clients_bloc.dart';

import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DashboardDataView extends StatelessWidget {
  const DashboardDataView({
    Key? key,
    required this.loading,
    required this.moneyFormatter,
    required this.dashData,
    this.userId,
  }) : super(key: key);

  final bool loading;
  final NumberFormat moneyFormatter;
  final DashData dashData;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizationCubit>().state.company!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All trackings:',
          style: TextStyle(color: kColorGreyText, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatCard(
                onPressed: () {},
                loading: loading,
                type: StatCardType.white,
                title: 'Hours',
                value: printDuration(dashData.totalDuration),
                subText: dashData.totalDurationChange.isNegative
                    ? 'h / last'
                    : '+${dashData.totalDurationChange.inHours}h / last',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: StatCard(
                  onPressed: () {},
                  loading: loading,
                  type: StatCardType.white,
                  title: 'Hourly rate',
                  value: moneyFormatter.format(dashData.totalHourlyRate),
                  subText: dashData.totalHourlyRateChange),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          'Clients trackings:',
          style: TextStyle(color: kColorGreyText, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatCard(
                onPressed: () {},
                loading: loading,
                type: StatCardType.white,
                title: 'Hours',
                value: printDuration(dashData.clientDuration),
                subText: dashData.clientDuration.isNegative
                    ? 'h / last'
                    : '+${dashData.clientDurationChange.inHours}h / last',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: StatCard(
                  onPressed: () {},
                  loading: loading,
                  type: StatCardType.white,
                  title: 'Hourly rate',
                  value: moneyFormatter.format(dashData.clientsHourlyRate),
                  subText: dashData.clientHourlyRateChange),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Internal trackings:',
          style: TextStyle(color: kColorGreyText, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatCard(
                onPressed: () {},
                loading: loading,
                type: StatCardType.white,
                title: 'Hours',
                value: printDuration(dashData.internalDuration),
                subText: dashData.internalDuration.isNegative
                    ? 'h / last'
                    : '+${dashData.internalDurationChange.inHours}h / last',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, state) {
            return CustomPieChart(
              title: 'Time distribution:',
              chartData: overviewShowingSections(
                userId: userId,
                clientsDuration: dashData.clientDuration,
                internalDuration: dashData.internalDuration,
                internals: state.clients
                    .where((element) => element.internal == true)
                    .toList(),
              ),
            );
          },
        ),
        SizedBox(
          height: 20,
        ),
        CustomPieChart(
            title: 'Time distribution on tags:',
            chartData: tagsShowingSections(
              tags: company.tags,
              tagsMap: dashData.tags,
            )),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
