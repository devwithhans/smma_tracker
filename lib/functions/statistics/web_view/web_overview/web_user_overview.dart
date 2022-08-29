import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/functions/get_employee_dash_data.dart';
import 'package:agency_time/functions/statistics/models/dashdata.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_widgets/pie_chart.dart';
import 'package:agency_time/functions/statistics/web_view/web_overview/widgets/overview_data_visualisation.dart';
import 'package:agency_time/functions/statistics/web_view/web_overview/widgets/overview_header.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserOverview extends StatefulWidget {
  const UserOverview({Key? key}) : super(key: key);

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  String? selectedToggls;
  String selectedGraphView = 'Total duration';
  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthCubit>().state.appUser!;
    Company company = context.read<AuthCubit>().state.company!;

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OverviewHeader(
                title: 'Your data',
                subText: 'Here is how you spend your time',
              ),
              BlocBuilder<StatsBloc, StatsState>(
                builder: (context, state) {
                  DashData dashData = getEmployeeDashData(
                    mrr: state.selectedMonth.mrr,
                    thisMonthEmployees: state.selectedMonth.employees,
                    lastMonthEmployees: state.compareMonth.employees,
                    userId: appUser.id,
                  );
                  return OverviewData(
                    cardsList: [
                      StatCardObject(
                          value: printDuration(dashData.totalDuration),
                          title: 'Total duration',
                          subValue: dashData.totalDurationChange.isNegative
                              ? 'h / last'
                              : '+${dashData.totalDurationChange.inHours}h / last',
                          graphDataSpots: state.months
                              .map(
                                (e) => GraphDataSpots(
                                    date: e.date!,
                                    value: e.employees
                                        .firstWhere((element) =>
                                            element.member.id == appUser.id)
                                        .totalDuration),
                              )
                              .toList()),
                      StatCardObject(
                          value: printDuration(dashData.clientDuration),
                          title: 'Clients duration',
                          subValue: dashData.clientDuration.isNegative
                              ? 'h / last'
                              : '+${dashData.clientDurationChange.inHours}h / last',
                          graphDataSpots: state.months
                              .map(
                                (e) => GraphDataSpots(
                                    date: e.date!,
                                    value: e.employees
                                        .firstWhere((element) =>
                                            element.member.id == appUser.id)
                                        .clientsDuration),
                              )
                              .toList()),
                      StatCardObject(
                          value: printDuration(dashData.internalDuration),
                          title: 'Internal duration',
                          subValue: dashData.internalDuration.isNegative
                              ? 'h / last'
                              : '+${dashData.internalDurationChange.inHours}h / last',
                          graphDataSpots: state.months
                              .map(
                                (e) => GraphDataSpots(
                                    date: e.date!,
                                    value: e.employees
                                        .firstWhere((element) =>
                                            element.member.id == appUser.id)
                                        .internalDuration),
                              )
                              .toList()),
                    ],
                    pieChartList: [
                      BlocBuilder<ClientsBloc, ClientsState>(
                        builder: (context, state) {
                          return Expanded(
                            child: CustomPieChart(
                                chartData: overviewShowingSections(
                                    internals: state.internalClients,
                                    clientsDuration: dashData.clientDuration,
                                    internalDuration:
                                        dashData.internalDuration),
                                title: 'Time distribution'),
                          );
                        },
                      ),
                      SizedBox(width: 20, height: 20),
                      Expanded(
                        child: CustomPieChart(
                            chartData: tagsShowingSections(
                              tags: company.tags,
                              tagsMap: dashData.tags,
                            ),
                            title: 'Time distribution on tags'),
                      ),
                      SizedBox(width: 20, height: 20),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 200),
      ],
    );
  }
}
