import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/dashdata.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/constants/text_styles.dart';

import '../data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class UserDataView extends StatelessWidget {
  const UserDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthorizationCubit>().state.appUser!;
    Company company = context.read<AuthorizationCubit>().state.company!;

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your performance',
                style: AppTextStyle.boldLarge,
              ),
              SizedBox(height: 40),
              BlocBuilder<StatsBloc, StatsState>(
                builder: (context, state) {
                  DashData dashData = getEmployeeDashData(
                    mrr: state.selectedMonth.mrr,
                    thisMonthEmployees: state.selectedMonth.employees,
                    lastMonthEmployees: state.compareMonth.employees,
                    userId: appUser.id,
                  );

                  return DataVisualisationTemplate(
                    cardsList: [
                      ValueCard(
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
                      ValueCard(
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
                      ValueCard(
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
                      const SizedBox(width: 20, height: 20),
                      Expanded(
                        child: CustomPieChart(
                            chartData: tagsShowingSections(
                              tags: company.tags,
                              tagsMap: dashData.tags,
                            ),
                            title: 'Time distribution on tags'),
                      ),
                      const SizedBox(width: 20, height: 20),
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
