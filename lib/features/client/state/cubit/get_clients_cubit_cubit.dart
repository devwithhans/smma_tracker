import 'dart:async';

import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/features/client/repository/client_repo.dart';
import 'package:agency_time/features/error/error.dart';
import 'package:agency_time/features/insights/models/month.dart';
import 'package:agency_time/models/month.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'get_clients_cubit_state.dart';

class GetClientsCubit extends Cubit<GetClientsState> {
  late StreamSubscription _clientsStream;
  final NewClientRepo clientRepo;

  GetClientsCubit(this.clientRepo) : super(GetClientsState()) {
    _clientsStream = clientRepo
        .clientsSubscription()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      for (var rawClient in event.docs) {
        _addClient(rawClient);
      }
    });
  }

  Future<void> _addClient(
      QueryDocumentSnapshot<Map<String, dynamic>> rawClient) async {
    Client client = clientRepo.getClientFromFirestoreResult(rawClient);

    List<Client> modifiedClientList = _addNewClientToList(newClient: client);

    List<Client> internals = [];
    try {
      List<Client> filtered =
          modifiedClientList.where((element) => element.internal).toList();
      internals.addAll(filtered);
    } catch (e) {
      print(e);
    }

    List<Client> clients = [];
    try {
      List<Client> filtered =
          modifiedClientList.where((element) => !element.internal).toList();
      clients.addAll(filtered);
    } catch (e) {
      print(e);
    }

    List<Client> myClients = [];
    try {
      List<Client> filtered = clients
          .where((element) => element.relations
              .containsKey(clientRepo.authCubit.state.appUser!.id))
          .toList();
      myClients.addAll(filtered);
    } catch (e) {
      print(e);
    }

    List<Client> myInternals = [];
    try {
      List<Client> filtered = internals
          .where((element) => element.relations
              .containsKey(clientRepo.authCubit.state.appUser!.id))
          .toList();
      myClients.addAll(filtered);
    } catch (e) {
      print(e);
    }

    emit(
      state.copyWith(
        allClients: clients,
        allInternals: internals,
        myClients: myClients,
        myInternals: myInternals,
      ),
    );
  }

  List<Client> _addNewClientToList({required Client newClient}) {
    List<Client> newClientList = [];

    newClientList.addAll(state.allClients);
    if (newClientList
        .where((element) => element.name == newClient.name)
        .isEmpty) {
      newClientList.add(newClient);
    } else {
      newClientList[newClientList.lastIndexWhere(
          (element) => element.name == newClient.name)] = newClient;
    }
    return newClientList;
  }

  offlineMonthUpdate({required Duration duration, required String clientId}) {
    List<Client> newClientList = [];
    newClientList.addAll(state.allClients);

    List<Client> clientToUpdateList =
        newClientList.where((element) => element.id == clientId).toList();
    if (clientToUpdateList.isEmpty) return;

    Client client = clientToUpdateList.last;
    MonthData selectedMonth = client.selectedMonth!;

    String userId = clientRepo.authCubit.state.appUser!.id;
    selectedMonth.employees
        .firstWhere((element) => element.member.id == userId)
        .totalDuration += duration;

    selectedMonth.totalDuration += duration;

    newClientList
        .firstWhere((element) => element.id == clientId)
        .selectedMonth = selectedMonth;
    emit(state.copyWith(allClients: newClientList, status: BlocStatus.loading));
    emit(state.copyWith(status: BlocStatus.initial));
  }
}
