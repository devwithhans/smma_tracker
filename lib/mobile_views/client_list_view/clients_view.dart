import 'package:agency_time/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/mobile_views/add_clients_view.dart';

import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/widgets/clients_card.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Clients',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddClientView(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add_circle),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('MMMM')
                              .format(state.month ?? DateTime.now()),
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          onPressed: () async {
                            DateTime? selectedDateTime = await showMonthPicker(
                              context: context,
                              initialDate: state.month ?? DateTime.now(),
                            );
                            context.read<ClientsBloc>().add(GetClientsWithMonth(
                                  month: selectedDateTime,
                                ));
                          },
                          icon: Icon(Icons.calendar_month),
                          splashRadius: 20,
                        ),
                      ],
                    )
                  ],
                ),
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentMonth
                                ? 'You dont have any client '
                                : 'You had no clients in ${DateFormat('MMMM').format(state.month!)}',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),
                          currentMonth
                              ? CustomElevatedButton(
                                  text: 'Add Client',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AddClientView.id);
                                  },
                                )
                              : CustomElevatedButton(
                                  text: 'Change month',
                                  onPressed: () async {
                                    DateTime? selectedDateTime =
                                        await showMonthPicker(
                                      lastDate: DateTime.now(),
                                      context: context,
                                      initialDate:
                                          state.month ?? DateTime.now(),
                                    );
                                    context
                                        .read<ClientsBloc>()
                                        .add(GetClientsWithMonth(
                                          month: selectedDateTime,
                                        ));
                                  },
                                )
                        ],
                      );
                    }
                    return Builder(
                      builder: (context) {
                        state.clients.sort(filterFuction);
                        searchResult = state.clients
                            .where((element) =>
                                element.name
                                    .toLowerCase()
                                    .contains(search.toLowerCase()) &&
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
                                context.read<TimerBloc>().add(TimerStarted(
                                    duration: Duration(),
                                    client: ClientLite.fromClient(
                                        searchResult[index])));
                              },
                              duration:
                                  searchResult[index].selectedMonth.duration,
                            );
                          }),
                        );
                      },
                    );
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
