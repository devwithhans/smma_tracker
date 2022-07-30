import 'dart:async';

import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/clientMonth.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  late StreamSubscription _clientsStream;
  final TrackerRepository trackerRepository;

  ClientsBloc({required this.trackerRepository}) : super(ClientsState()) {
    _clientsStream = trackerRepository
        .clientsSubscription()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      List<Client> clients = [];
      clients.addAll(state.clients); // Gets already loaded clients

      for (var clientRaw in event.docs) {
        add(AddClient(client: clientRaw));
      }
    });

    on<ClientsEvent>((event, emit) {});
    on<AddClient>(_addClient);
  }

  Future<void> _addClient(AddClient event, Emitter emit) async {
    Map<String, dynamic> clientMap = event.client.data();

    /// MONTH ///

    DateTime currentDate = DateTime.now();

    DateTime month = event.month ?? currentDate;
    DateTime compareMonth =
        event.month ?? DateTime(currentDate.year, currentDate.month - 1);

    String monthId = '${month.year}-${month.month}';
    String compareMonthId = '${compareMonth.year}-${compareMonth.month}';

    Map<String, dynamic>? monthData = clientMap[monthId] ??
        await trackerRepository.getClientMonth(monthId, event.client.id);
    Map<String, dynamic>? compareMonthData = clientMap[compareMonthId] ??
        await trackerRepository.getClientMonth(compareMonthId, event.client.id);

    Month? monthModel = Month.convertClient(monthData);
    Month? compareMonthModel = Month.convertClient(compareMonthData);

    if (monthModel == null) {
      showSimpleNotification(
        Text(
          'Something went wrong with ${clientMap['name']}',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        background: Colors.red,
      );
      return;
    }

    /// MONTH ///

    Client client = Client(
      id: event.client.id,
      name: clientMap['name'],
      updatedAt: clientMap['updatedAt'],
      compareMonth: compareMonthModel,
      selectedMonth: monthModel,
    );
    List<Client> newClientList = [];
    newClientList.addAll(state.clients);

    if (newClientList.where((element) => element.name == client.name).isEmpty) {
      newClientList.add(client);
    } else {
      newClientList[newClientList
          .lastIndexWhere((element) => element.name == client.name)] = client;
    }

    emit(state.copyWith(clients: newClientList));
  }
}
