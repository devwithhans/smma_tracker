import 'package:agency_time/features/client/presentation/add_client/add_client.dart';
import 'package:agency_time/logic/clients/clients_bloc/clients_bloc.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/widgets/client_list_result/client_list_result.dart';
import 'package:agency_time/utils/widgets/client_list_result/column_row.dart';
import 'package:agency_time/utils/widgets/client_list_result/web_list_header.dart';
import 'package:agency_time/views/sheet_add_client/shared/add_client_sheet.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../../features/client/models/client.dart';

class WebClientsView extends StatefulWidget {
  const WebClientsView({Key? key}) : super(key: key);

  @override
  State<WebClientsView> createState() => _WebClientsViewState();
}

class _WebClientsViewState extends State<WebClientsView> {
  String searchParameter = '';
  List<Client> searchResult = [];

  @override
  Widget build(BuildContext context) {
    String countryCode =
        context.read<AuthorizationCubit>().state.company!.countryCode;
    NumberFormat moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: countryCode);

    return Scaffold(
      body: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          searchResult = state.clients
              .where((element) => '${element.name} ${element.name} '
                  .toLowerCase()
                  .contains(searchParameter.toLowerCase()))
              .toList();
          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WebListHeader(
                searchHint: 'Search clients',
                title: 'Clients',
                onPlusPressed: () {
                  SideSheet.right(
                      body: AddClientSheet(), context: context, width: 500);
                },
                currentMonth: state.month ?? DateTime.now(),
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
              // const RowExplaination(),
              const SizedBox(height: 20),
              const Divider(height: 0),
              ClientListResult(
                  searchResult: searchResult, moneyFormatter: moneyFormatter),
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
