import 'package:agency_time/utils/widgets/custom_app_bar.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

class ClientStatsSheet extends StatelessWidget {
  const ClientStatsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizationCubit>().state.company!;

    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);
    return Column(
      children: [
        const CustomAppBar(
          title: 'Stats for ',
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: StatCard(
                //     onPressed: () {},
                //     type: StatCardType.white,
                //     title: 'MRR',
                //     value: moneyFormatter.format(23000),
                //     subText: 2,
                //   ),
                // ),
                // StatCard(
                //   onPressed: () {},
                //   type: StatCardType.white,
                //   title: 'Hourly rate',
                //   value: moneyFormatter.format(23000),
                //   subText: 2,
                // ),
                // StatCard(
                //   onPressed: () {},
                //   type: StatCardType.white,
                //   title: 'Tracked time',
                //   value: moneyFormatter.format(23000),
                //   subText: 2,
                // ),
              ],
            )
          ],
        ))
      ],
    );
  }
}
