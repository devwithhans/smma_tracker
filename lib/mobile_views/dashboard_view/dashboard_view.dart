import 'package:agency_time/functions/data_explanation.dart';
import 'package:agency_time/mobile_views/client_list_view/clients_view.dart';
import 'package:agency_time/mobile_views/dashboard_view/dashboard_widgets/custom_app_bar.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/clients_card.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:agency_time/blocs/clients_cubit/clients_cubit.dart';
import 'package:agency_time/utils/widgets/revenue_card.dart';

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
              child: BlocBuilder<ClientsCubit, ClientsState>(
                builder: (context, state) {
                  print(state.lastMonth.mrr);
                  Duration durationChange =
                      state.thisMonth.duration - state.lastMonth.duration;

                  return ListView(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    children: [
                      StatCard(
                        title: 'Monthly revenue',
                        value: moneyFormatter.format(state.thisMonth.mrr),
                        subText: getChangeProcentage(
                          state.thisMonth.mrr,
                          state.lastMonth.mrr,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              type: StatCardType.white,
                              title: 'Total hours',
                              value: printDuration(state.thisMonth.duration),
                              subText: durationChange.isNegative
                                  ? 'h / last'
                                  : '+${durationChange.inHours}h / last',
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: StatCard(
                              type: StatCardType.white,
                              title: 'Avg. hourly rate',
                              value: moneyFormatter
                                  .format(state.thisMonth.hourlyRate),
                              subText: getChangeProcentage(
                                state.thisMonth.hourlyRate,
                                state.lastMonth.hourlyRate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Top 3 best performance:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Column(
                          children: returnBestClients(state.clients)
                              .map((e) => ClientCard(
                                  client: e, duration: e.thisMonth!.duration))
                              .toList()),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Top 3 worst performance:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Column(
                          children: returnWorstClients(state.clients)
                              .map((e) => ClientCard(
                                  client: e, duration: e.thisMonth!.duration))
                              .toList()),
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

  List<Client> returnBestClients(List<Client> clients) {
    List<Client> result = [];
    result.addAll(clients);

    result.sort(filters['Hourly Rate']![false]);
    return result.take(3).toList();
  }

  List<Client> returnWorstClients(List<Client> clients) {
    List<Client> result = [];
    result.addAll(clients);

    result.sort(filters['Hourly Rate']![true]);
    return result.take(3).toList();
  }
}
