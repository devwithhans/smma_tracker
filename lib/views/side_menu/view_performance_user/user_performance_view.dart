import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/sorting.dart';

import '../../../features/client/models/client.dart';
import '../../view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class UserPerformanceView extends StatelessWidget {
  const UserPerformanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthorizeCubit>().state.appUser!;
    Company company = context.read<AuthorizeCubit>().state.company!;
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
                'Last activity:',
                style: AppTextStyle.boldMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  BlocBuilder<ClientsBloc, ClientsState>(
                    builder: (context, state) {
                      if (state.relationClients.isEmpty) {
                        return Text('Please wait till we recieve your data');
                      }
                      List<Client> result = state.allClients;
                      // result.sort((a, b) =>
                      //     sortClientByUsersLastActivity(appUser.id, a, b));
                      return Column(
                        children: result.map((e) => Text(e.name)).toList(),
                      );
                    },
                  ),
                  const SizedBox()
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 200),
      ],
    );
  }
}
