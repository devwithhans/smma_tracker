import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/features/client/presentation/add_client/add_client.dart';
import 'package:agency_time/features/client/presentation/list_clients/widgets/filters.dart';
import 'package:agency_time/features/client/presentation/list_clients/widgets/list_header.dart';
import 'package:agency_time/features/client/presentation/list_clients/widgets/list_result.dart';
import 'package:agency_time/features/client/state/cubit/get_clients_cubit_cubit.dart';
import 'package:agency_time/features/client/utils/filters.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/widgets/client_list_result/column_row.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/views/sheet_add_client/shared/add_client_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:side_sheet/side_sheet.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({Key? key}) : super(key: key);

  @override
  State<ClientsView> createState() => _WebClientsViewState();
}

class _WebClientsViewState extends State<ClientsView> {
  String searchParameter = '';
  List<Client> searchResult = [];
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        SideSheet.right(body: AddClientSheet(), context: context, width: 500));
  }

  @override
  Widget build(BuildContext context) {
    AuthorizeState authState = context.read<AuthorizeCubit>().state;
    String countryCode = authState.company!.countryCode;
    NumberFormat moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: countryCode);

    Map<String, Function> sorts =
        ClientSorts(authState.appUser!.id).getClientFilters();

    return Scaffold(
      body: BlocBuilder<GetClientsCubit, GetClientsState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const LoadingScreen();
          }

          searchResult = state.allClients
              .where((element) => '${element.name} ${element.name} '
                  .toLowerCase()
                  .contains(searchParameter.toLowerCase()))
              .toList();

          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListHeader(
                searchHint: 'Search clients',
                title: 'Clients',
                onPlusPressed: () {
                  SideSheet.right(
                      body: AddClientSheet(), context: context, width: 500);
                },
                currentMonth: DateTime.now(),
                onSearch: (v) {
                  searchParameter = v;
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
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
                searchResult: searchResult,
                moneyFormatter: moneyFormatter,
              ),
              SizedBox(
                height: 400,
              )
            ],
          );
        },
      ),
    );
  }
}
