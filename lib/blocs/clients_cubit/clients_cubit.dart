import 'dart:async';

import 'package:agency_time/functions/data_explanation.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/clientMonth.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  late StreamSubscription _clientsStream;
  String companyId;

  ClientsCubit(this.companyId)
      : super(ClientsState(thisMonth: Month(), lastMonth: Month())) {
    _clientsStream = FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('clients')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      List<Client> clients = [];
      clients.addAll(state.clients); // Gets already loaded clients

      DateTime thisMonthDate = DateTime.now();
      DateTime lastMonthDate =
          DateTime(thisMonthDate.year, thisMonthDate.month - 1, 1);

      String lastMonthString = '${lastMonthDate.year}-${lastMonthDate.month}';
      String thisMonthString = '${thisMonthDate.year}-${thisMonthDate.month}';

      Month thisTotalMonth = Month();
      Month lastTotalMonth = Month();

      for (var client in event.docs) {
        Month? thisMonth;
        Month? lastMonth;
        if (client.data()['months'] != null) {
          if (client['months'][thisMonthString] != null) {
            Map<String, dynamic> thisMonthRaw =
                client['months'][thisMonthString];
            thisMonth = Month.convertClient(thisMonthRaw, client['mrr']);
            thisTotalMonth.mrr = thisTotalMonth.mrr + thisMonth.mrr;
            thisTotalMonth.duration =
                thisTotalMonth.duration + thisMonth.duration;
          }
          if (client['months'][lastMonthString] != null) {
            Map<String, dynamic> lastMonthRaw =
                client['months'][thisMonthString];
            lastMonth = Month.convertClient(lastMonthRaw, client['mrr']);
            lastTotalMonth.mrr = lastTotalMonth.mrr + lastMonth.mrr;
            lastTotalMonth.duration =
                lastTotalMonth.duration + lastMonth.duration;
          }
        }

        bool lastMonthExists = lastMonth != null;

        double mrrChange = getChangeProcentage(
            thisMonth!.mrr, lastMonthExists ? lastMonth.mrr : 0);
        double durationChange = getChangeProcentage(
            thisMonth.duration.inSeconds,
            lastMonthExists ? lastMonth.duration.inSeconds : 0);
        double hourlyRateChange = getChangeProcentage(
            getHourlyRate(thisMonth.mrr, thisMonth.duration),
            lastMonth != null
                ? getHourlyRate(lastMonth.mrr,
                    lastMonthExists ? thisMonth.duration : Duration())
                : 0);

        Client newClient = Client(
          id: client.id,
          name: client['name'],
          mrr: thisMonth.mrr,
          mrrChange: mrrChange,
          durationChange: durationChange,
          updatedAt: thisMonth != null ? thisMonth.updatedAt : null,
          hourlyRateTarget: client['hourly_rate_target'],
          thisMonth: thisMonth,
          lastMonth: lastMonth ?? Month(),
        );

        if (clients
            .where((element) => element.name == newClient.name)
            .isEmpty) {
          clients.add(newClient);
        } else {
          clients[clients.lastIndexWhere(
              (element) => element.name == newClient.name)] = newClient;
        }
      }

      thisTotalMonth.hourlyRate =
          thisTotalMonth.mrr / thisTotalMonth.duration.inHours;

      print(thisTotalMonth.hourlyRate);

      emit(
        state.copyWith(
          clients: clients,
          thisMonth: thisTotalMonth,
          lastMonth: lastTotalMonth,
        ),
      );
    });
  }
}
