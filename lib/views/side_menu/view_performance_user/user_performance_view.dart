import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/constants/text_styles.dart';

import '../../view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:intl/intl.dart';

class UserPerformanceView extends StatelessWidget {
  const UserPerformanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthorizationCubit>().state.appUser!;
    Company company = context.read<AuthorizationCubit>().state.company!;

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s get to work ${appUser.firstName}',
                style: AppTextStyle.boldLarge,
              ),
              const SizedBox(height: 40),
              Text(
                'Your clients:',
                style: AppTextStyle.boldMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  BlocBuilder<ClientsBloc, ClientsState>(
                    builder: (context, state) {
                      return Expanded(
                        child: Container(
                          height: 500,
                          child: ListView(
                            children:
                                state.clients.map((e) => Text(e.name)).toList(),
                          ),
                        ),
                      );
                    },
                  ),
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
