import 'dart:async';
import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/insights/models/month.dart';
import 'package:agency_time/logic/clients/repos/client_repo.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/month.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../features/client/models/client.dart';
part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  late StreamSubscription _clientsStream;
  final ClientsRepo clientsRepo;
  final Company company;

  ClientsBloc({
    required this.clientsRepo,
    required this.company,
  }) : super(const ClientsState()) {
    //We listen for changes in the clients, and adds the changes to the state
    _clientsStream = clientsRepo
        .clientsSubscription()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      print(event);
      for (var clientRaw in event.docs) {
        add(AddClient(client: clientRaw));
      }
      // if (event.docs.isEmpty) {
      //   showDialog(
      //     context: navigatorKey.currentContext!,
      //     builder: (context) => Dialog(
      //       child: Center(
      //         child: Container(
      //           child: Text('Welcome to SMMA TRacker'),
      //         ),
      //       ),
      //     ),
      //   );
      // }
    });

    on<AddClient>(_addClient);
    on<OfflineMonthUpdate>(_offlineMonthUpdate);

    @override
    Future<void> close() {
      _clientsStream.cancel();
      return super.close();
    }
  }

  _offlineMonthUpdate(OfflineMonthUpdate event, Emitter emit) {
    List<Client> newClientList = [];
    newClientList.addAll(state.clients);

    List<Client> clientToUpdateList =
        newClientList.where((element) => element.id == event.clientId).toList();
    if (clientToUpdateList.isEmpty) return;

    Client client = clientToUpdateList.last;
    MonthData selectedMonth = client.selectedMonth!;

    String userId = clientsRepo.authCubit.state.appUser!.id;
    selectedMonth.employees
        .firstWhere((element) => element.member.id == userId)
        .totalDuration += event.duration;

    selectedMonth.totalDuration += event.duration;

    newClientList
        .firstWhere((element) => element.id == event.clientId)
        .selectedMonth = selectedMonth;
    emit(state.copyWith(clients: newClientList, status: Status.loading));
    emit(state.copyWith(status: Status.initial));
  }

  Future<void> _addClient(AddClient event, Emitter emit) async {
    Client client = Client.fromFirestoreResult(event.client, company);

    List<Client> modifiedClientList = _addNewClientToList(newClient: client);

    List<Client> internals = [];
    try {
      List<Client> filtered = modifiedClientList
          .where((element) => element.internal == true)
          .toList();
      internals.addAll(filtered);
    } catch (e) {}

    List<Client> clients = [];
    try {
      List<Client> filtered =
          modifiedClientList.where((element) => !element.internal).toList();
      clients.addAll(filtered);
    } catch (e) {}
    List<Client> relationClients = [];

    try {
      List<Client> filtered = modifiedClientList
          .where((element) => element.relations
              .containsKey(clientsRepo.authCubit.state.appUser!.id))
          .toList();
      relationClients.addAll(filtered);
    } catch (e) {}

    emit(
      state.copyWith(
        clients: clients,
        internalClients: internals,
        allClients: modifiedClientList,
        relationClients: relationClients,
      ),
    );
  }

  // Checking if the client already exists in the array, and if so it updates it, otherwise it adds it to the old array.
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
}
