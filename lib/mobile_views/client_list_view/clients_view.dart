import 'package:agency_time/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/mobile_views/client_list_view/components/client_result_list.dart';
import 'package:agency_time/mobile_views/client_list_view/components/client_view_header.dart';
import 'package:agency_time/mobile_views/client_list_view/components/no_clients.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({Key? key}) : super(key: key);

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  int Function(Client, Client)? filterFuction = filters['Latest']![true];
  List<Client> searchResult = [];
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
                state: state,
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
                        .where((element) => element.activeMonth)
                        .toList();
                    bool currentMonth = state.month == null ||
                        state.month!.month == DateTime.now().month;
                    if (clients.isEmpty) {
                      return NoClients(
                        currentMonth: currentMonth,
                        state: state,
                      );
                    }
                    return ClientResultList(state: state, search: search);
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

Map<String, Map<bool, int Function(Client, Client)?>> filters = {
  'Latest': {
    true: sortOnLatest,
    false: sortOnLatest,
  },
  'Name': {
    true: sortAlphabetical,
    false: inversSortAlphabetical,
  },
  'MRR': {
    true: inversSortOnMrr,
    false: sortOnMrr,
  },
  'Change': {
    true: sortOnChange,
    false: inversSortOnChange,
  },
  'Hourly Rate': {
    true: sortOnHourlyRate,
    false: inversSortOnHourlyRate,
  },
};

int sortAlphabetical(Client a, Client b) {
  var aName = a.name.toLowerCase();
  var bName = b.name.toLowerCase();
  return aName.compareTo(bName);
}

int inversSortAlphabetical(Client a, Client b) {
  var aName = a.name.toLowerCase();
  var bName = b.name.toLowerCase();
  return bName.compareTo(aName);
}

int sortOnHourlyRate(Client a, Client b) {
  double houryRateA = a.selectedMonth.mrr / (a.selectedMonth.duration.inHours);
  double houryRateB = b.selectedMonth.mrr / (b.selectedMonth.duration.inHours);
  if (houryRateA < houryRateB) {
    return -1;
  } else if (houryRateA > houryRateB) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnHourlyRate(Client a, Client b) {
  double houryRateA = a.selectedMonth.mrr / (a.selectedMonth.duration.inHours);
  double houryRateB = b.selectedMonth.mrr / (b.selectedMonth.duration.inHours);
  if (houryRateA > houryRateB) {
    return -1;
  } else if (houryRateA < houryRateB) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnMrr(a, b) {
  if (a.selectedMonth!.mrr > b.selectedMonth!.mrr) {
    return -1;
  } else if (a.selectedMonth!.mrr < b.selectedMonth!.mrr) {
    return 1;
  } else {
    return 0;
  }
}

int sortOnMrr(a, b) {
  if (a.selectedMonth!.mrr < b.selectedMonth!.mrr) {
    return -1;
  } else if (a.selectedMonth!.mrr > b.selectedMonth!.mrr) {
    return 1;
  } else {
    return 0;
  }
}

int sortOnLatest(Client a, Client b) {
  if (a.updatedAt == null && b.updatedAt == null) {
    return 0;
  } else if (a.updatedAt == null) {
    return 1;
  } else if (b.updatedAt == null) {
    return -1;
  } else {
    return b.updatedAt!.compareTo(a.updatedAt!);
  }
}

int sortOnChange(Client a, Client b) {
  double aChange = ((a.selectedMonth.duration.inSeconds -
          a.compareMonth!.duration.inSeconds) /
      a.selectedMonth.duration.inSeconds *
      100);
  double bChange = ((b.selectedMonth.duration.inSeconds -
          b.compareMonth!.duration.inSeconds) /
      b.selectedMonth.duration.inSeconds *
      100);

  aChange = aChange.isInfinite || aChange.isNaN ? -10000 : aChange;
  bChange = bChange.isInfinite || bChange.isNaN ? -10000 : bChange;

  if (aChange > bChange) {
    return -1;
  } else if (aChange < bChange) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnChange(Client a, Client b) {
  double aChange = ((a.selectedMonth.duration.inSeconds -
          a.compareMonth!.duration.inSeconds) /
      a.selectedMonth.duration.inSeconds *
      100);
  double bChange = ((b.selectedMonth.duration.inSeconds -
          b.compareMonth!.duration.inSeconds) /
      b.selectedMonth.duration.inSeconds *
      100);

  aChange = aChange.isInfinite || aChange.isNaN ? -10000 : aChange;
  bChange = bChange.isInfinite || bChange.isNaN ? -10000 : bChange;

  if (aChange < bChange) {
    return -1;
  } else if (aChange > bChange) {
    return 1;
  } else {
    return 0;
  }
}
