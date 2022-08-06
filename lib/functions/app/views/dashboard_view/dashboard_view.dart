import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/models/stats.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_widgets/custom_app_bar.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/revenue_card.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFormatter =
        NumberFormat.currency(locale: 'da', name: 'kr.', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   toolbarHeight: 70,
      //   title: const CustomAppBar(),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            Expanded(
              child: BlocBuilder<StatsBloc, StatsState>(
                builder: (context, state) {
                  // Duration durationChange =
                  //     state.thisMonth.duration - state.lastMonth.duration;
                  bool loading = state.status == Status.loading;
                  CompanyMonth selectedMonth = state.selectedMonth;

                  if (state.status == Status.loading) return SizedBox();

                  return ListView(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    children: [
                      StatCard(
                        loading: loading,
                        title: 'Monthly revenue',
                        value: moneyFormatter.format(selectedMonth.mrr),
                        subText: state.mrrChange,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              loading: loading,
                              type: StatCardType.white,
                              title: 'Total hours',
                              value: printDuration(selectedMonth.totalDuration),
                              subText: selectedMonth.internalDuration.isNegative
                                  ? 'h / last'
                                  : '+${state.totalDurationChange.inHours}h / last',
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: StatCard(
                                loading: loading,
                                type: StatCardType.white,
                                title: 'Avg. hourly rate',
                                value: moneyFormatter
                                    .format(selectedMonth.totalHourlyRate),
                                subText: state.hourlyRateChange),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              loading: loading,
                              type: StatCardType.white,
                              title: 'Client hours',
                              value:
                                  printDuration(selectedMonth.clientsDuration),
                              subText: state.clientsDurationChange.isNegative
                                  ? 'h / last'
                                  : '+${state.clientsDurationChange.inHours}h / last',
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: StatCard(
                                loading: loading,
                                type: StatCardType.white,
                                title: 'Avg. hourly rate',
                                value: moneyFormatter
                                    .format(selectedMonth.totalHourlyRate),
                                subText: state.hourlyRateChange),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
