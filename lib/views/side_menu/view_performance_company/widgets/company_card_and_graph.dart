import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/logic/data_visualisation/blocs/data_bloc/data_bloc.dart';
import 'package:agency_time/models/company.dart';

import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/client_list_result/client_list_result.dart';
import 'package:agency_time/utils/widgets/custom_toggl_button.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';

import '../../../view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class ValueCard {
  final String title;
  final String value;
  final dynamic subValue;

  const ValueCard({
    required this.title,
    required this.subValue,
    required this.value,
  });
}

class GraphAndCards extends StatefulWidget {
  const GraphAndCards({
    Key? key,
  }) : super(key: key);

  @override
  State<GraphAndCards> createState() => _GraphAndCardsState();
}

class _GraphAndCardsState extends State<GraphAndCards> {
  String selectedGraph = '';
  @override
  void initState() {
    super.initState();
  }

  List<GraphDataSpots> selectedGraphSpot = [];

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizeCubit>().state.company!;
    final NumberFormat moneyFormatter = CustomCurrencyFormatter.getFormatter(
        countryCode: company.countryCode, short: false);

    GlobalKey buttonKey = GlobalKey(); // declare a global key

    return BlocBuilder<DataBloc, DataState>(
      builder: (c, state) {
        if (state.dataStatus == DataStatus.loading) {
          return const Center(
            child: Text('loading'),
          );
        }
        if (state.currentMonth == null || state.compareMonth == null) {}

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      StatCard(
                        valueCard: ValueCard(
                          value: printDuration(
                              state.currentMonth!.durationData.totalDuration),
                          title: 'Total duration ',
                          subValue: state.changes.totalDuration.isNegative
                              ? 'h / last'
                              : '+${state.changes.totalDuration.inHours}h / last',
                        ),
                        selectedGraph: selectedGraph,
                        onPressed: (v) {
                          selectedGraph = v;
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 20),
                      StatCard(
                        valueCard: ValueCard(
                          value: printDuration(
                              state.currentMonth!.durationData.clientDuration),
                          title: 'Client duration',
                          subValue: state.changes.clientDuration.isNegative
                              ? 'h / last'
                              : '+${state.changes.clientDuration.inHours}h / last',
                        ),
                        selectedGraph: selectedGraph,
                        onPressed: (v) {
                          selectedGraph = v;
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 20),
                      StatCard(
                        valueCard: ValueCard(
                          value: printDuration(state
                              .currentMonth!.durationData.internalDuration),
                          title: 'Internal duration',
                          subValue: state.changes.internalDuration.isNegative
                              ? 'h / last'
                              : '+${state.changes.internalDuration.inHours}h / last',
                        ),
                        selectedGraph: selectedGraph,
                        onPressed: (v) {
                          selectedGraph = v;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      StatCard(
                        onPressed: (v) {
                          selectedGraph = v;
                          setState(() {});
                        },
                        valueCard: ValueCard(
                          value: moneyFormatter.format(
                              state.currentMonth!.durationData.totalHourlyRate),
                          title: 'Total hourly rate',
                          subValue: state.changes.totalHourlyRate,
                        ),
                        selectedGraph: selectedGraph,
                      ),
                      const SizedBox(width: 20),
                      StatCard(
                        onPressed: (v) {
                          selectedGraph = v;
                          setState(() {});
                        },
                        valueCard: ValueCard(
                          value: moneyFormatter.format(state
                              .currentMonth!.durationData.clientHourlyRate),
                          title: 'Clients hourly rate',
                          subValue: state.changes.clientHourlyRate,
                        ),
                        selectedGraph: selectedGraph,
                      ),
                      const SizedBox(width: 20),
                      StatCard(
                        onPressed: (v) {
                          selectedGraph = v;
                          setState(() {});
                        },
                        valueCard: ValueCard(
                          value: moneyFormatter.format(state.currentMonth!.mrr),
                          title: 'Monthly revenue',
                          subValue: state.changes.mrr,
                        ),
                        selectedGraph: selectedGraph,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company history',
                    style: AppTextStyle.boldMedium,
                  ),
                  Text(
                    'Tap on the cards above to change data',
                    style: AppTextStyle.fatGray,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: CustomToggl(
                      buttons: const ['Week', 'Month', 'Year'],
                      selected: 'Week',
                      onPressed: (v) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: UniversalGraph(
                        graphDataSpots: state.allDays
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.durationData.totalDuration,
                                dateString: '',
                              ),
                            )
                            .toList(),
                        moneyFormatter: moneyFormatter),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ClientsBloc, ClientsState>(
                      builder: (context, clientState) {
                        return CustomPieChart(
                          chartData: overviewShowingSections(
                            internals: clientState.internalClients,
                            clientsDuration:
                                state.currentMonth!.durationData.clientDuration,
                            internalDuration: state
                                .currentMonth!.durationData.internalDuration,
                          ),
                          title: 'Time split',
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomPieChart(
                      chartData: tagsShowingSections(
                          tags: company.tags,
                          tagsMap: state.currentMonth!.tags),
                      title: 'Tags',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomPieChart(
                      chartData: employeesShowingSections(
                          userTrackings: state.currentMonth!.userTracking,
                          users: company.members),
                      title: 'Tags',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top 3 hourly rate',
                    style: AppTextStyle.boldMedium,
                  ),
                  Text(
                    'Maybe you should spend some more time here?',
                    style: AppTextStyle.fatGray,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 0,
            ),
            BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                return ClientListResult(
                    searchResult: state.clients,
                    moneyFormatter: moneyFormatter);
              },
            )
          ],
        );
      },
    );
  }
}
