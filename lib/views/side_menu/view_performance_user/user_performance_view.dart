import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/client_list_result/client_list_result.dart';
import 'package:agency_time/utils/widgets/client_list_result/two_line_text.dart';

import '../../view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class UserPerformanceView extends StatelessWidget {
  const UserPerformanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthorizationCubit>().state.appUser!;
    Company company = context.read<AuthorizationCubit>().state.company!;
    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s GOOOOOO ${appUser.firstName}',
                style: AppTextStyle.boldLarge,
              ),
              const SizedBox(height: 40),
              Text(
                'Your clients:',
                style: AppTextStyle.boldMedium,
              ),
              const SizedBox(height: 20),
              BlocBuilder<ClientsBloc, ClientsState>(
                builder: (context, state) {
                  return ClientListResult(
                      searchResult: state.relationClients,
                      moneyFormatter: moneyFormatter);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 200),
      ],
    );
  }
}
