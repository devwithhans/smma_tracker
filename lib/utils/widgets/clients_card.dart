import 'package:agency_time/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/mobile_views/client_view/client_view.dart';
import 'package:agency_time/models/client.dart';
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
    required this.duration,
    this.isTracking = false,
    this.onDoubleTap,
  }) : super(key: key);

  final Client client;
  Duration duration;
  bool isTracking;
  final void Function()? onDoubleTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClientView(
                      client: client,
                    )));
      },
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          int intDuration = duration.inSeconds;
          if (state is TimerRunning && state.client.id == client.id) {
            intDuration += state.duration;

            isTracking = true;
          }

          final moneyFormatter = NumberFormat.currency(
              locale: 'da', name: 'Kr.', decimalDigits: 0);

          double currentHouryRate = client.mrr / duration.inHours;
          double lastHouryRate = client.lastMonth!.mrr;
          double hourlyRateChange =
              (currentHouryRate - lastHouryRate) / currentHouryRate * 100;

          Duration durationChange =
              client.thisMonth!.duration - client.lastMonth!.duration;

          return Container(
            height: 90,
            padding: EdgeInsets.all(10),
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
                        Text(
                          '${moneyFormatter.format(client.mrr)} / mth',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
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
                          durationChange.isNegative
                              ? 'h / last'
                              : '+${durationChange.inHours}h / last',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentHouryRate > 50000
                              ? '+50k'
                              : '${moneyFormatter.format(currentHouryRate)} ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: client.thisMonth!.hourlyRate <
                                    client.hourlyRateTarget
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        ProcentageChange(
                            procentage: hourlyRateChange.isInfinite
                                ? 100
                                : hourlyRateChange)
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
