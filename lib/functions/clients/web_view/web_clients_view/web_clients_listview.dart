import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/functions/clients/web_view/web_client_view.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/finish_tracking_view.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:side_sheet/side_sheet.dart';

class WebClientsView extends StatefulWidget {
  const WebClientsView({Key? key}) : super(key: key);

  @override
  State<WebClientsView> createState() => _WebClientsViewState();
}

class _WebClientsViewState extends State<WebClientsView> {
  String searchParameter = '';
  List<Client> searchResult = [];

  @override
  Widget build(BuildContext context) {
    String countryCode = context.read<AuthCubit>().state.company!.countryCode;
    NumberFormat moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: countryCode);

    return Scaffold(
      body: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          searchResult = state.clients
              .where((element) => '${element.name} ${element.name} '
                  .toLowerCase()
                  .contains(searchParameter.toLowerCase()))
              .toList();
          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Clients overview',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () {
                                SideSheet.right(
                                    body: AddClientView(),
                                    context: context,
                                    width: 500);
                              },
                              icon: const Icon(Icons.add_circle),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 300,
                          child: CustomSearchField(
                            hintText: 'Search clients',
                            onSearch: (v) {
                              searchParameter = v;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    CustomMonthButton(
                        icon: Icons.calendar_month,
                        onPressed: () async {
                          DateTime? selection = await showMonthPicker(
                            firstDate: context
                                .read<StatsBloc>()
                                .state
                                .months
                                .first
                                .date!,
                            lastDate: context
                                .read<StatsBloc>()
                                .state
                                .months
                                .last
                                .date!,
                            context: context,
                            initialDate: state.month ?? DateTime.now(),
                          );
                          if (selection != null) {
                            context
                                .read<StatsBloc>()
                                .add(GetStats(month: selection));
                            context
                                .read<ClientsBloc>()
                                .add(GetClientsWithMonth(month: selection));
                          }
                        },
                        text: DateFormat('MMM, y')
                            .format(state.month ?? DateTime.now()))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const RowExplaination(),
              const SizedBox(height: 20),
              const Divider(height: 0),
              Column(
                children: searchResult.map((e) {
                  return ClientRow(
                    moneyFormatter: moneyFormatter,
                    client: e,
                  );
                }).toList(),
              ),
              SizedBox(
                height: 400,
              )
            ],
          );
        },
      ),
    );
  }
}

class RowExplaination extends StatelessWidget {
  const RowExplaination({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            child: Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              'Tracking',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              'Hourly rate',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              'Last tracking',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientRow extends StatelessWidget {
  const ClientRow({
    Key? key,
    required this.moneyFormatter,
    required this.client,
  }) : super(key: key);

  final NumberFormat moneyFormatter;
  final Client client;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        bool isTracking;
        bool isLoading;
        List<Employee> employeeDataList = client.selectedMonth.employees
            .where((element) =>
                element.member.id ==
                context.read<AuthCubit>().state.appUser!.id)
            .toList();

        Employee? employeeData =
            employeeDataList.isNotEmpty ? employeeDataList.first : null;

        Duration duration = true
            ? employeeData != null
                ? employeeData.totalDuration
                : Duration()
            : client.selectedMonth.duration;

        int intDuration = duration.inSeconds;
        if (state is TimerRunning && state.client.id == client.id) {
          intDuration += state.duration;
          isLoading = state.loading;
          isTracking = true;
        } else {
          isLoading = false;
          isTracking = false;
        }
        if (isLoading) {
          return Container(
            height: 90,
            color: Colors.black,
          );
        }
        return Column(
          children: [
            RawMaterialButton(
              onPressed: () {
                SideSheet.right(
                    width: 800,
                    body: WebClientView(client: client),
                    context: context);
              },
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${client.name}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${moneyFormatter.format(client.selectedMonth.mrr)}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            printDuration(Duration(seconds: intDuration)),
                            style: TextStyle(fontSize: 16),
                          ),

                          Text(
                            client.durationChange.isNegative
                                ? '- ${printDuration(client.durationChange)} / last'
                                : '+ ${printDuration(client.durationChange)} / last',
                            style: const TextStyle(fontSize: 10),
                          ),
                          // ? '${compareDuration.inHours}h / last'
                          // : '+${compareDuration.inHours}h / last',
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moneyFormatter
                                .format(client.selectedMonth.hourlyRate),
                            style: TextStyle(fontSize: 16),
                          ),
                          ProcentageChange(
                              procentage: client.hourlyRateChange.isFinite
                                  ? client.hourlyRateChange
                                  : 100)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEE, dd MMM HH:MM ')
                                .format(client.selectedMonth.updatedAt),
                            style: TextStyle(fontSize: 16),
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              if (isTracking && state is TimerRunning) {
                                TimerRunning timerState = state as TimerRunning;

                                SideSheet.right(
                                    width: 500,
                                    body: FinishTrackingDialog(
                                      onDelete: () {
                                        context
                                            .read<TrackerRepo>()
                                            .deleteTracking(
                                                trackingDocId:
                                                    timerState.documentId!);
                                      },
                                      onSave: (Tag? newTag, Duration duration) {
                                        context.read<TimerBloc>().add(
                                              TimerReset(
                                                  duration: duration,
                                                  newTag: newTag),
                                            );
                                      },
                                      client: timerState.client,
                                      duration: Duration(
                                          seconds: timerState.duration),
                                      tags:
                                          context.read<ClientsRepo>().getTags(),
                                    ),
                                    context: context);
                              } else {
                                context.read<TimerBloc>().add(
                                      TimerStarted(
                                        client: ClientLite.fromClient(client),
                                        duration: Duration(),
                                      ),
                                    );
                              }
                            },
                            fillColor: isTracking ? kColorBlack : kColorGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              isTracking
                                  ? Icons.stop_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            // Text(
                            //   'START TRACKER',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
          ],
        );
      },
    );
  }
}
