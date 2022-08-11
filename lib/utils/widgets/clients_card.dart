import 'package:agency_time/functions/app/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/views/client_view/client_view.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/tracking/blocs/update_trackig_cubit/update_tracking_cubit.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';

import 'package:agency_time/utils/widgets/procentage_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClientCard extends StatelessWidget {
  ClientCard({
    Key? key,
    required this.client,
    this.isTracking = false,
    this.onDoubleTap,
    this.personalTrackings = true,
  }) : super(key: key);

  final Client client;
  final bool personalTrackings;
  bool isTracking;
  final void Function()? onDoubleTap;
  @override
  Widget build(BuildContext context) {
    String userId = context.read<AuthCubit>().state.appUser!.id;
    List<Employee> employeeDataList = client.selectedMonth.employees
        .where((element) => element.member.id == userId)
        .toList();

    Employee? employeeData =
        employeeDataList.isNotEmpty ? employeeDataList.first : null;

    Duration duration = personalTrackings
        ? employeeData != null
            ? employeeData.totalDuration
            : Duration()
        : client.selectedMonth.duration;

    final moneyFormatter = NumberFormat.simpleCurrency(
        locale: context.read<SettingsBloc>().state.countryCode);

    bool noCompareMonth = client.compareMonth == null;

    Duration compareDuration = noCompareMonth
        ? const Duration()
        : client.compareMonth!.duration - client.selectedMonth.duration;
    double compareHourlyRate = getChangeProcentage(
        noCompareMonth ? 0 : client.selectedMonth.hourlyRate,
        client.selectedMonth.hourlyRate);

    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientView(
                client: client,
              ),
            ));
      },
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          int intDuration = duration.inSeconds;
          if (state is TimerRunning && state.client.id == client.id) {
            intDuration += state.duration;
            isTracking = true;
          } else {
            isTracking = false;
          }
          return Container(
            height: 90,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: isTracking
                  ? Border.all(color: Colors.black, width: 2)
                  : Border.all(color: kColorGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        client.internal
                            ? SizedBox()
                            : Text(
                                '${moneyFormatter.format(client.selectedMonth.mrr)}',
                                style: TextStyle(fontSize: 12),
                              ),
                      ],
                    ),
                  ),
                ),
                client.internal
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            printDuration(Duration(seconds: intDuration)),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            compareDuration.isNegative
                                ? '${compareDuration.inHours}h / last'
                                : '+${compareDuration.inHours}h / last',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      )
                    : Expanded(
                        flex: 6,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                printDuration(Duration(seconds: intDuration)),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Text(
                                compareDuration.isNegative
                                    ? '${compareDuration.inHours}h / last'
                                    : '+${compareDuration.inHours}h / last',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                client.internal
                    ? SizedBox()
                    : Expanded(
                        flex: 5,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client.selectedMonth.hourlyRate > 50000
                                    ? '+50k'
                                    : '${moneyFormatter.format(client.selectedMonth.hourlyRate)} ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: client.selectedMonth.hourlyRate <
                                          client.selectedMonth.hourlyRateTarget
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                              ProcentageChange(
                                  procentage: compareHourlyRate.isInfinite
                                      ? 100
                                      : compareHourlyRate)
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
