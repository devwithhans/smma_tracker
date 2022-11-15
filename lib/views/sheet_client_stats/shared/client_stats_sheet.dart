import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/widgets/custom_app_bar.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/views/sheet_edit_client/shared/edit_client_sheet.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../../features/client/models/client.dart';
import '../../../utils/widgets/buttons/text_button.dart';

class ClientStatsSheet extends StatelessWidget {
  const ClientStatsSheet({required this.client, Key? key}) : super(key: key);

  final Client client;
  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizationCubit>().state.company!;

    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);
    return Column(
      children: [
        CustomAppBar(
          title: 'Stats for ${client.name}',
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            CustomTextButton(
              onPressed: () {
                SideSheet.right(
                  width: 500,
                  body: EditClientSheet(
                    client: client,
                  ),
                  context: context,
                );
              },
              text: 'EDIT',
            ),
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
