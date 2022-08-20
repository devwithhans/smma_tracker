// ignore_for_file: depend_on_referenced_packages

import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/functions/get_employee_dash_data.dart';
import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/app/models/dashdata.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_widgets/pie_chart.dart';
import 'package:agency_time/utils/widgets/graph.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_toggl_button.dart';
import 'package:agency_time/utils/widgets/revenue_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class WebOverview extends StatefulWidget {
  const WebOverview({Key? key}) : super(key: key);

  @override
  State<WebOverview> createState() => _WebOverviewState();
}

String? selectedToggls;
String selectedGraphView = 'Monthly recuring revenue';

class _WebOverviewState extends State<WebOverview> {
  @override
  Widget build(BuildContext context) {
    /// App data:
    AppUser appUser = context.read<AuthCubit>().state.appUser!;
    Company company = context.read<AuthCubit>().state.company!;

    /// Correct currency format:
    final moneyFormatter = NumberFormat.simpleCurrency(
        locale: company.countryCode, decimalDigits: 0);

    /// Responsive variables.
    double width = MediaQuery.of(context).size.width - 500;
    int gridWidth = 10;
    double breakPoint = 1500;
    bool breaked = width > breakPoint;
    int widePart(double procentage) =>
        breaked ? (gridWidth * procentage).ceil() : 10;

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: BlocBuilder<StatsBloc, StatsState>(
            builder: (context, state) {
              /// The Company data and the current users data as a map.
              Map<String, DashData> togglsData = {
                'Company data': monthToDashData(state),
                'My data': getEmployeeDashData(
                  mrr: state.selectedMonth.mrr,
                  thisMonthEmployees: state.selectedMonth.employees,
                  lastMonthEmployees: state.compareMonth.employees,
                  userId: appUser.id,
                ),
              };

              /// Map that contains the different graph options.
              Map togglGraph = {
                'Monthly recuring revenue': state.months
                    .map(
                      (e) => CustomGraphModel(
                        date: e.date!,
                        value: e.mrr,
                      ),
                    )
                    .toList(),
                'Total duration': state.months
                    .map(
                      (e) => CustomGraphModel(
                        date: e.date!,
                        value: selectedToggls == togglsData.keys.first
                            ? e.totalDuration
                            : e.employees
                                .firstWhere((element) =>
                                    element.member.id == appUser.id)
                                .totalDuration,
                      ),
                    )
                    .toList(),
                'Hourly rate': state.months
                    .map(
                      (e) => CustomGraphModel(
                        date: e.date!,
                        value: selectedToggls == togglsData.keys.first
                            ? e.totalHourlyRate
                            : e.employees
                                .firstWhere((element) =>
                                    element.member.id == appUser.id)
                                .totalHourlyRate,
                      ),
                    )
                    .toList(),
              };

              /// The current selected togglsData, that will be displayed in the whole UI
              DashData statsData =
                  togglsData[selectedToggls ?? togglsData.keys.first]!;

              /// All the cards are places in a list outside of the main widget, to shift between row or collumn
              List<Widget> cardsList = [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectedGraphView = 'Monthly recuring revenue';
                      setState(() {});
                    },
                    child: StatCard(
                      expanded: true,
                      type: selectedGraphView == 'Monthly recuring revenue'
                          ? StatCardType.black
                          : StatCardType.white,
                      title: 'Monthly Requring Revenue',
                      value: moneyFormatter.format(statsData.mrr ?? 0),
                      subText: state.mrrChange,
                    ),
                  ),
                ),
                SizedBox(height: 20, width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectedGraphView = 'Total duration';
                      setState(() {});
                    },
                    child: StatCard(
                      expanded: true,
                      type: selectedGraphView == 'Total duration'
                          ? StatCardType.black
                          : StatCardType.white,
                      title: 'Total duration',
                      value: printDuration(statsData.totalDuration),
                      subText: statsData.totalDurationChange.isNegative
                          ? 'h / last'
                          : '+${statsData.totalDurationChange.inHours}h / last',
                    ),
                  ),
                ),
                SizedBox(height: 20, width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectedGraphView = 'Hourly rate';
                      setState(() {});
                    },
                    child: StatCard(
                      expanded: true,
                      type: selectedGraphView == 'Hourly rate'
                          ? StatCardType.black
                          : StatCardType.white,
                      title: 'Hourly rate',
                      value: moneyFormatter.format(statsData.totalHourlyRate),
                      subText: statsData.totalHourlyRateChange,
                    ),
                  ),
                ),
              ];

              List<Widget> pieChartList = [
                Expanded(
                  child: BlocBuilder<ClientsBloc, ClientsState>(
                    builder: (context, state) {
                      return CustomPieChart(
                        title: 'Time distribution:',
                        size: MediaQuery.of(context).size.width * 0.03,
                        chartData: overviewShowingSections(
                          thickness: 15,
                          userId: appUser.id,
                          clientsDuration: statsData.clientDuration,
                          internalDuration: statsData.internalDuration,
                          internals: state.clients
                              .where((element) => element.internal == true)
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 20, height: 20),
                Expanded(
                  child: CustomPieChart(
                    size: MediaQuery.of(context).size.width * 0.03,
                    title: 'Time distribution on tags:',
                    chartData: tagsShowingSections(
                      thickness: 15,
                      tags: company.tags,
                      tagsMap: statsData.tags,
                    ),
                  ),
                ),
                SizedBox(width: 20, height: 20),
                Expanded(
                  child: CustomPieChart(
                    size: MediaQuery.of(context).size.width * 0.03,
                    title: 'Time distribution on tags:',
                    chartData: employeesShowingSections(
                      thickness: 15,
                      employees: state.selectedMonth.employees,
                    ),
                  ),
                ),
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning, ${appUser.firstName}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Let\'s checkout how your company spend it\'s time',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 400,
                            child: CustomToggl(
                                buttons: togglsData.keys.toList(),
                                selected:
                                    selectedToggls ?? togglsData.keys.first,
                                onPressed: (v) {
                                  selectedToggls = v;
                                  setState(() {});
                                }),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      CustomMonthButton(
                        icon: Icons.calendar_month,
                        onPressed: () {},
                        text: DateFormat('MMM, y').format(DateTime.now()),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      StaggeredGrid.count(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        crossAxisCount: gridWidth,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: widePart(0.4),
                            mainAxisCellCount: breaked ? 3 : 2,
                            child: Builder(builder: (context) {
                              if (widePart(0.4) == 10) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: cardsList,
                                );
                              } else {
                                return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: cardsList);
                              }
                            }),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: widePart(0.6),
                            mainAxisCellCount: breaked ? 3 : 5,
                            child: SizedBox(
                              child: togglGraph[selectedGraphView].isNotEmpty
                                  ? CustomGraph(
                                      title: selectedGraphView,
                                      months: togglGraph[selectedGraphView],
                                    )
                                  : Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(),
                                    ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: widePart(1),
                            mainAxisCellCount: breaked ? 2.1 : 7,
                            child: Builder(builder: (context) {
                              if (widePart(0.4) == 10) {
                                return Column(
                                  children: pieChartList,
                                );
                              } else {
                                return Row(children: pieChartList);
                              }
                            }),
                          ),
                        ],
                      ),
                      // SizedBox(height: 20),
                      // SizedBox(
                      //   child: !breaked
                      //       ? Column(
                      //           children: pieChartList,
                      //         )
                      //       : Row(children: pieChartList),
                      // ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

monthToDashData(StatsState state) {
  CompanyMonth selectedMonth = state.selectedMonth;
  return DashData(
    mrr: selectedMonth.mrr,
    clientDuration: selectedMonth.clientsDuration,
    clientDurationChange: state.clientsDurationChange,
    tags: selectedMonth.tags,
    totalDuration: selectedMonth.totalDuration,
    totalDurationChange: state.totalDurationChange,
    totalHourlyRate: selectedMonth.totalHourlyRate,
    totalHourlyRateChange: state.totalHourlyRateChange,
    clientHourlyRateChange: state.clientsHourlyRateChange,
    clientsHourlyRate: selectedMonth.clientsHourlyRate,
    internalDuration: selectedMonth.internalDuration,
    internalDurationChange: state.internalDurationChange,
  );
}
