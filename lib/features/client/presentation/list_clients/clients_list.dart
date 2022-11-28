import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/client/presentation/add_client/add_client.dart';
import 'package:agency_time/features/client/presentation/list_clients/widgets/list_result.dart';
import 'package:agency_time/features/client/presentation/widgets/custom_web_tab.dart';
import 'package:agency_time/features/client/state/cubit/get_clients_cubit_cubit.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/utils/widgets/client_list_result/column_row.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetClientsCubit, GetClientsState>(
        builder: (context, state) {
      print(state.allClients);
      AuthorizeState authState = context.read<AuthorizeCubit>().state;
      String countryCode = authState.company!.countryCode;

      NumberFormat moneyFormatter =
          CustomCurrencyFormatter.getFormatter(countryCode: countryCode);
      if (state.status == BlocStatus.loading) {
        return const LoadingScreen();
      }
      if (state.allClients == []) {
        return const LoadingScreen();
      }
      return CustomWebTab(
        buttons: [
          CustomElevatedButton(
            text: 'Add Client',
            onPressed: () async {
              addClient(context);
            },
          ),
        ],
        title: 'Clients',
        tabs: [
          TabScreen(
              screen: ListView(
                children: [
                  ColumnRow(
                    items: [
                      Text(
                        'Name',
                        style: AppTextStyle.boldSmall,
                      ),
                      Text(
                        'Duration',
                        style: AppTextStyle.boldSmall,
                      ),
                      Text(
                        'Hourly Rate',
                        style: AppTextStyle.boldSmall,
                      ),
                      Text(
                        'Last tracking',
                        style: AppTextStyle.boldSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 0),
                  ListResult(
                    searchResult: state.allClients,
                    moneyFormatter: moneyFormatter,
                  ),
                  SizedBox(
                    height: 4000,
                  )
                ],
              ),
              title: 'Clients'),
          TabScreen(
              screen: Expanded(
                child: ListView(
                  children: [
                    ColumnRow(
                      items: [
                        Text(
                          'Name',
                          style: AppTextStyle.boldSmall,
                        ),
                        Text(
                          'Duration',
                          style: AppTextStyle.boldSmall,
                        ),
                        Text(
                          'Last tracking',
                          style: AppTextStyle.boldSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 0),
                    ListResult(
                      searchResult: state.allInternals,
                      moneyFormatter: moneyFormatter,
                    ),
                    const SizedBox(
                      height: 4000,
                    )
                  ],
                ),
              ),
              title: 'Internals')
        ],
      );
    });
  }
}
