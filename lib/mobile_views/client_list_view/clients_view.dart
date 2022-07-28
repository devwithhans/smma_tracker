import 'package:agency_time/blocs/clients_cubit/clients_cubit.dart';
import 'package:agency_time/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/mobile_views/add_clients_view.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/widgets/clients_card.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: Column(
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddClient(),
                          ),
                        );
                      },
                      icon: Icon(Icons.add_circle),
                      splashRadius: 20,
                    )
                  ],
                ),
                CircleAvatar()
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
            child: BlocBuilder<ClientsCubit, ClientsState>(
              builder: (context, state) {
                if (state.clients.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You dont have any clients yet',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 20,
                      ),
                      CustomElevatedButton(
                        text: 'Add Client',
                        onPressed: () {
                          Navigator.pushNamed(context, AddClient.id);
                        },
                      )
                    ],
                  );
                }
                return Builder(
                  builder: (context) {
                    state.clients.sort(filterFuction);
                    searchResult = state.clients
                        .where((element) => element.name
                            .toLowerCase()
                            .contains(search.toLowerCase()))
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
                                client: searchResult[index]));
                          },
                          duration: searchResult[index].thisMonth!.duration,
                        );
                      }),
                    );
                  },
                );
              },
            ),
          )
        ],
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
  double houryRateA = a.mrr / (a.thisMonth!.duration.inHours);
  double houryRateB = b.mrr / (b.thisMonth!.duration.inHours);
  if (houryRateA < houryRateB) {
    return -1;
  } else if (houryRateA > houryRateB) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnHourlyRate(Client a, Client b) {
  double houryRateA = a.mrr / (a.thisMonth!.duration.inHours);
  double houryRateB = b.mrr / (b.thisMonth!.duration.inHours);
  if (houryRateA > houryRateB) {
    return -1;
  } else if (houryRateA < houryRateB) {
    return 1;
  } else {
    return 0;
  }
}

int inversSortOnMrr(a, b) {
  if (a.mrr > b.mrr) {
    return -1;
  } else if (a.mrr < b.mrr) {
    return 1;
  } else {
    return 0;
  }
}

int sortOnMrr(a, b) {
  if (a.mrr < b.mrr) {
    return -1;
  } else if (a.mrr > b.mrr) {
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
  double aChange =
      ((a.thisMonth!.duration.inSeconds - a.lastMonth!.duration.inSeconds) /
          a.thisMonth!.duration.inSeconds *
          100);
  double bChange =
      ((b.thisMonth!.duration.inSeconds - b.lastMonth!.duration.inSeconds) /
          b.thisMonth!.duration.inSeconds *
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
  double aChange =
      ((a.thisMonth!.duration.inSeconds - a.lastMonth!.duration.inSeconds) /
          a.thisMonth!.duration.inSeconds *
          100);
  double bChange =
      ((b.thisMonth!.duration.inSeconds - b.lastMonth!.duration.inSeconds) /
          b.thisMonth!.duration.inSeconds *
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
