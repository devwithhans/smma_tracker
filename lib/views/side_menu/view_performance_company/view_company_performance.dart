import '../../view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/models/company.dart';
import 'package:intl/intl.dart';

class ViewCompanyPerformance extends StatelessWidget {
  const ViewCompanyPerformance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthorizationCubit>().state.company!;

    // final NumberFormat moneyFormatter = CustomCurrencyFormatter.getFormatter(
    //     countryCode: company.countryCode, short: false);

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
            const SizedBox(height: 30),
            Column(
              children: const [
                GraphAndCards(),
              ],
            )
          ],
        ),
        const SizedBox(height: 200),
      ],
    );
  }
}
