import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/client_view/widgets/client_stats.dart';
import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/models/dashdata.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_widgets/pie_chart.dart';
import 'package:agency_time/functions/statistics/web_view/web_overview/widgets/overview_data_visualisation.dart';
import 'package:agency_time/functions/statistics/web_view/web_overview/widgets/overview_header.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_graph.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyOverview extends StatelessWidget {
  const CompanyOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthCubit>().state.company!;

    final NumberFormat moneyFormatter = CustomCurrencyFormatter.getFormatter(
        countryCode: company.countryCode, short: false);

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OverviewHeader(
                title: 'Here is how your company spend it\'s time',
                subText: 'Take a look at your stats',
              ),
              BlocBuilder<StatsBloc, StatsState>(
                builder: (context, state) {
                  if (state.status == StatsStatus.loading) {
                    return LoadingScreen();
                  }

                  DashData dashData = DashData.getDashData(
                      compareMonth: state.compareMonth,
                      selectedMonth: state.selectedMonth);
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
                                    date: e.date!, value: e.totalDuration),
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
                                    date: e.date!, value: e.clientsDuration),
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
                                    date: e.date!, value: e.internalDuration),
                              )
                              .toList()),
                      StatCardObject(
                          value:
                              moneyFormatter.format(dashData.totalHourlyRate),
                          title: 'Total hourly rate',
                          subValue: dashData.totalHourlyRateChange,
                          graphDataSpots: state.months
                              .map(
                                (e) => GraphDataSpots(
                                    date: e.date!, value: e.totalHourlyRate),
                              )
                              .toList()),
                      StatCardObject(
                          value:
                              moneyFormatter.format(dashData.clientsHourlyRate),
                          title: 'Clients hourly rate',
                          subValue: dashData.clientHourlyRateChange,
                          graphDataSpots: state.months
                              .map(
                                (e) => GraphDataSpots(
                                    date: e.date!, value: e.clientsHourlyRate),
                              )
                              .toList()),
                      StatCardObject(
                          value: moneyFormatter.format(dashData.selectedMrr),
                          title: 'MRR',
                          subValue: dashData.changeMrr,
                          graphDataSpots: state.months
                              .map(
                                (e) =>
                                    GraphDataSpots(date: e.date!, value: e.mrr),
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
                      Expanded(
                        child: CustomPieChart(
                            chartData: employeesShowingSections(
                                employees: state.selectedMonth.employees),
                            title: 'Who track the most?'),
                      ),
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
