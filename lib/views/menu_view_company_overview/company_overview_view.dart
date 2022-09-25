import 'package:agency_time/models/company.dart';
import 'package:agency_time/new_data_handling/blocs/data_bloc/data_bloc.dart';
import 'package:agency_time/new_data_handling/models/duration_data.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import '../view_data_visualisation/data_visualisation_dependencies.dart';
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
            BlocBuilder<DataBloc, DataState>(builder: (context, state) {
              if (state.currentMonth == null || state.compareMonth == null) {
                return const Center(
                  child: Text('loading'),
                );
              }

              DurationData selectedDurations = state.currentMonth!.durationData;
              DurationData compareDurations = state.compareMonth!.durationData;

              return Column(
                children: [
                  GraphAndCards(
                    cardsList: [
                      ValueCard(
                        value: printDuration(
                            state.currentMonth!.durationData.totalDuration),
                        title: 'Total duration',
                        subValue: state.changes.totalDuration.isNegative
                            ? 'h / last'
                            : '+${state.changes.totalDuration.inHours}h / last',
                        graphDataSpots: state.currentMonth!.days
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.durationData.totalDuration,
                              ),
                            )
                            .toList(),
                      ),
                      ValueCard(
                        value: printDuration(
                            state.currentMonth!.durationData.clientDuration),
                        title: 'Client duration',
                        subValue: state.changes.clientDuration.isNegative
                            ? 'h / last'
                            : '+${state.changes.clientDuration.inHours}h / last',
                        graphDataSpots: state.allDays
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.durationData.clientDuration,
                              ),
                            )
                            .toList(),
                      ),
                      ValueCard(
                        value: printDuration(
                            state.currentMonth!.durationData.internalDuration),
                        title: 'Internal duration',
                        subValue: state.changes.internalDuration.isNegative
                            ? 'h / last'
                            : '+${state.changes.internalDuration.inHours}h / last',
                        graphDataSpots: state.currentMonth!.days
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.durationData.internalDuration,
                              ),
                            )
                            .toList(),
                      ),
                      ValueCard(
                        value: moneyFormatter.format(
                            state.currentMonth!.durationData.totalHourlyRate),
                        title: 'Total hourly rate',
                        subValue: state.changes.totalHourlyRate,
                        graphDataSpots: state.currentMonth!.days
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.durationData.totalHourlyRate,
                              ),
                            )
                            .toList(),
                      ),
                      ValueCard(
                        value: moneyFormatter.format(
                            state.currentMonth!.durationData.clientHourlyRate),
                        title: 'Clients hourly rate',
                        subValue: state.changes.clientHourlyRate,
                        graphDataSpots: state.currentMonth!.days
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.durationData.clientHourlyRate,
                              ),
                            )
                            .toList(),
                      ),
                      ValueCard(
                        value: moneyFormatter.format(state.currentMonth!.mrr),
                        title: 'Monthly revenue',
                        subValue: state.changes.mrr,
                        graphDataSpots: state.currentMonth!.days
                            .map(
                              (e) => GraphDataSpots(
                                date: e.dayDate,
                                value: e.revenue,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: 200),
      ],
    );
  }
}
