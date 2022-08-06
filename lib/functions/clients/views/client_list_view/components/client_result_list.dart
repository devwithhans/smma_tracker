import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/client_list_view/clients_view.dart';
import 'package:agency_time/functions/clients/views/client_list_view/sorting_logic.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/utils/widgets/clients_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientResultList extends StatelessWidget {
  const ClientResultList({
    Key? key,
    required this.clients,
    required this.search,
  }) : super(key: key);

  final List<Client> clients;
  final String search;

  @override
  Widget build(BuildContext context) {
    int Function(Client, Client)? filterFuction = filters['Latest']![true];

    List<Client> searchResult = [];
    clients.sort(filterFuction);
    searchResult = clients
        .where((element) =>
            element.name.toLowerCase().contains(search.toLowerCase()) &&
            element.activeMonth)
        .toList();
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: searchResult.length,
      itemBuilder: ((c, index) {
        return ClientCard(
          client: searchResult[index],
          isTracking: false,
          onDoubleTap: () {
            HapticFeedback.mediumImpact();
            BlocProvider.of<TimerBloc>(context).add(TimerStarted(
                duration: Duration(),
                client: ClientLite.fromClient(searchResult[index])));
          },
          duration: searchResult[index].selectedMonth.duration,
        );
      }),
    );
  }
}
