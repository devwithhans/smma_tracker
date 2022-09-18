import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/dashdata.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';

import '../data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class CompanyDataView extends StatelessWidget {
  const CompanyDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizationCubit>().state.company!;

    final NumberFormat moneyFormatter = CustomCurrencyFormatter.getFormatter(
        countryCode: company.countryCode, short: false);

    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Company overview',
                    style: AppTextStyle.boldLarge,
                  ),
                  Row(
                    children: [
                      CustomElevatedButton(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        text: 'Download report',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 20),
                      CustomElevatedButton(
                        text: 'Add client',
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            BlocBuilder<StatsBloc, StatsState>(
              builder: (context, state) {
                if (state.status == StatsStatus.loading) {
                  return const LoadingScreen();
                }

                DashData dashData = DashData.getDashData(
                    compareMonth: state.compareMonth,
                    selectedMonth: state.selectedMonth);

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
                                  date: e.date!, value: e.totalDuration),
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
                                  date: e.date!, value: e.clientsDuration),
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
                                  date: e.date!, value: e.internalDuration),
                            )
                            .toList()),
                    ValueCard(
                        value: moneyFormatter.format(dashData.totalHourlyRate),
                        title: 'Total hourly rate',
                        subValue: dashData.totalHourlyRateChange,
                        graphDataSpots: state.months
                            .map(
                              (e) => GraphDataSpots(
                                  date: e.date!, value: e.totalHourlyRate),
                            )
                            .toList()),
                    ValueCard(
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
                    ValueCard(
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
                                  internalDuration: dashData.internalDuration),
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
        const SizedBox(height: 200),
      ],
    );
  }
}
