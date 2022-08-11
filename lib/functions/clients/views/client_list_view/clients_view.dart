import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/functions/clients/views/client_list_view/components/client_result_list.dart';
import 'package:agency_time/functions/clients/views/client_list_view/components/client_view_header.dart';
import 'package:agency_time/functions/clients/views/client_list_view/components/no_clients.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/clients/views/client_list_view/sorting_logic.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({Key? key}) : super(key: key);

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  int Function(Client, Client)? filterFuction = filters['Latest']![true];
  String search = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                selectedMonth: state.month ?? DateTime.now(),
                onSelectMonth: () async {
                  DateTime? selection = await showMonthPicker(
                    firstDate:
                        context.read<StatsBloc>().state.months.first.date!,
                    lastDate: context.read<StatsBloc>().state.months.last.date!,
                    context: context,
                    initialDate: state.month ?? DateTime.now(),
                  );
                  if (selection != null) {
                    context.read<StatsBloc>().add(GetStats(month: selection));
                    context
                        .read<ClientsBloc>()
                        .add(GetClientsWithMonth(month: selection));
                  }
                },
                title: 'Clients',
                state: state,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddClientView(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomSearchField(
                  hintText: 'Search for client',
                  onSearch: (value) {
                    search = value;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 10),
              FiltersScroll(
                inital: 'Latest',
                filters: filters.keys.toList(),
                onTap: (v, topDown) {
                  filterFuction = filters[v]![topDown];
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: Builder(
                  builder: (context) {
                    List<Client> clients = state.clients
                        .where((element) =>
                            element.internal != true && element.activeMonth)
                        .toList();
                    clients.sort(filterFuction);
                    bool currentMonth = state.month == null ||
                        state.month!.month == DateTime.now().month;
                    if (clients.isEmpty) {
                      return NoClients(
                        currentMonth: currentMonth,
                        state: state,
                      );
                    }
                    return ClientResultList(clients: clients, search: search);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
