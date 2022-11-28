import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/custom_toggl_button.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class ClientInsights extends StatelessWidget {
  const ClientInsights({required this.client, super.key});

  final Client client;

  @override
  Widget build(BuildContext context) {
    AuthorizeState authState = context.read<AuthorizeCubit>().state;
    String countryCode = authState.company!.countryCode;

    NumberFormat moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: countryCode);
    return Column(
      children: [
        Row(
          children: [
            StatCard(
              valueCard: ValueCard(
                  title: 'Monthly revenue', value: '20', subValue: 20),
              selectedGraph: 'selectedGraph',
              onPressed: (v) {},
            ),
            SizedBox(width: 20),
            StatCard(
              valueCard: ValueCard(
                  title: 'Tracked time',
                  value: printDuration(Duration(seconds: 500)),
                  subValue: 20),
              selectedGraph: 'selectedGraph',
              onPressed: (v) {},
            ),
            SizedBox(width: 20),
            StatCard(
              valueCard:
                  ValueCard(title: 'Hourly rate', value: '20', subValue: 20),
              selectedGraph: 'selectedGraph',
              onPressed: (v) {},
            )
          ],
        ),
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
                child: UniversalGraph(graphDataSpots: [
                  GraphDataSpots(
                      date: DateTime.now(), value: 500, dateString: '')
                ], moneyFormatter: moneyFormatter),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
