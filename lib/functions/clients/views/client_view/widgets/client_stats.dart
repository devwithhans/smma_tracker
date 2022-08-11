import 'package:agency_time/functions/app/views/dashboard_view/dashboard_view.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_widgets/pie_chart.dart';
import 'package:agency_time/functions/app/views/dashboard_view/total_view.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/clients/models/month.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:agency_time/utils/widgets/revenue_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientStats extends StatefulWidget {
  const ClientStats({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  State<ClientStats> createState() => _ClientStatsState();
}

class _ClientStatsState extends State<ClientStats> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;
    String role = authState.role ?? 'user';
    Company company = BlocProvider.of<AuthCubit>(context).state.company!;

    DashData privateDashData = getEmployeeDashData(
      mrr: widget.client.selectedMonth.mrr,
      lastMrr: widget.client.compareMonth != null
          ? widget.client.compareMonth!.mrr
          : 0,
      userId: authState.appUser!.id,
      nonFilterEmployee: widget.client.selectedMonth.employees,
    );
    Month selectedMonth = widget.client.selectedMonth;
    Month compareMonth = widget.client.compareMonth ??
        Month(date: DateTime.now(), updatedAt: DateTime.now());

    DashData totalDashData = DashData(
        tags: selectedMonth.tags,
        totalDuration: selectedMonth.duration,
        totalDurationChange: selectedMonth.duration - compareMonth.duration,
        totalHourlyRate: selectedMonth.hourlyRate,
        totalHourlyRateChange: getChangeProcentage(
            selectedMonth.hourlyRate, compareMonth.hourlyRate));

    Map<String, Widget> views = {
      'My Data': StatSection(dashData: privateDashData, company: company),
      'Total Data': StatSection(dashData: totalDashData, company: company),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatCard(
          title: 'Monthly revenue',
          value: moneyFormatter.format(privateDashData.mrr),
          subText: getChangeProcentage(
              privateDashData.mrr, privateDashData.lastMrr ?? 0),
        ),
        SizedBox(height: 15),
        role == 'owner'
            ? CustomToggl(
                buttons: views.keys.toList(),
                selected: selected ?? views.keys.first,
                onPressed: (e) {
                  selected = e;
                  setState(() {});
                },
              )
            : SizedBox(),
        views[selected ?? views.keys.first]!
      ],
    );
  }
}

class StatSection extends StatelessWidget {
  const StatSection({
    Key? key,
    required this.dashData,
    required this.company,
  }) : super(key: key);

  final DashData dashData;
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: StatCard(
                type: StatCardType.white,
                title: 'Time',
                value: printDuration(dashData.totalDuration),
                subText: dashData.totalDurationChange.inHours.isNegative
                    ? 'h / last'
                    : '+${dashData.totalDurationChange.inHours}h / last',
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: StatCard(
                  type: StatCardType.white,
                  title: 'Hourly rate',
                  value: moneyFormatter.format(dashData.totalHourlyRate),
                  subText: dashData.totalHourlyRateChange),
            ),
          ],
        ),
        SizedBox(height: 15),
        CustomPieChart(
            chartData:
                tagsShowingSections(tagsMap: dashData.tags, tags: company.tags),
            title: 'Time distribution on tags:'),
        SizedBox(height: 10),
      ],
    );
  }
}

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({required this.client, Key? key}) : super(key: key);

  final Client client;

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kColorGrey),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Hours',
                        style: TextStyle(color: kColorGreyText),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        printDuration(widget.client.selectedMonth.duration),
                        style: const TextStyle(
                            fontSize: 35,
                            height: 1,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      ProcentageChange(
                          procentage: getChangeProcentage(
                              widget.client.selectedMonth.duration,
                              widget.client.compareMonth!.duration)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text('hi'),
        ],
      ),
      //   ],
      // ),
    );
  }
}
