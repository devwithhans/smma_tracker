import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/views/lists_view/web/widgets/client_list_result.dart';
import 'package:agency_time/views/lists_view/web/widgets/column_row.dart';
import 'package:agency_time/views/lists_view/web/widgets/web_list_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

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
                      body: AddClientView(), context: context, width: 500);
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
