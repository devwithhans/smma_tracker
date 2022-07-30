import 'dart:async';

import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/clientMonth.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  late StreamSubscription _clientsStream;
  final TrackerRepository trackerRepository;

  ClientsBloc({required this.trackerRepository}) : super(ClientsState()) {
    //We listen for changes in the clients, and adds the changes to the state
    _clientsStream = trackerRepository
        .clientsSubscription()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      for (var clientRaw in event.docs) {
        add(AddClient(client: clientRaw));
      }
    });

    on<AddClient>(_addClient);
    on<GetClientsWithMonth>(_setClientMonth);

    @override
    Future<void> close() {
      _clientsStream.cancel();
      return super.close();
    }
  }

  // Selecting the months
  Future<void> _setClientMonth(GetClientsWithMonth event, Emitter emit) async {
    emit(state.copyWith(month: event.month, compareMonth: event.compareMonth));

    List<Client> updatedClients = [];
    for (var client in state.clients) {
      DateTime selectedDate = event.month ?? DateTime.now();

      DateTime compareDate = event.compareMonth ??
          DateTime(selectedDate.year, selectedDate.month - 1);

      List<Month> selectedMonthList = client.savedMonths
          .where((element) => element.month.month == selectedDate.month)
          .toList();
      List<Month> compareMonthList = client.savedMonths
          .where((element) => element.month.month == compareDate.month)
          .toList();

      Month? selectedMonth =
          selectedMonthList.isNotEmpty ? selectedMonthList.last : null;
      Month? compareMonth =
          compareMonthList.isNotEmpty ? compareMonthList.last : null;

      if (selectedMonth == null) {
        updatedClients.add(client.copyWith(activeMonth: false));
        break;
      }

      updatedClients.add(client.copyWith(
          selectedMonth: selectedMonth,
          compareMonth: compareMonth,
          activeMonth: true));
    }
    emit(state.copyWith(clients: updatedClients));
  }

  Future<void> _addClient(AddClient event, Emitter emit) async {
    Map<String, dynamic> clientMap = event.client.data();
    Map<String, dynamic> monthsMap = clientMap['months'] ?? {};
    List<Month> savedMonths = [];
    monthsMap.forEach((key, value) {
      savedMonths.add(Month.convertMonth(value, key)!);
    });

    Client client = Client(
      id: event.client.id,
      name: clientMap['name'],
      savedMonths: savedMonths,
      updatedAt: clientMap['updatedAt'],
      compareMonth: savedMonths.length > 0 ? null : savedMonths[1],
      selectedMonth: savedMonths[0],
    );

    // We modify the list, updates if the client exists and adds if it does not exist
    List<Client> modifiedClientList = _addNewClientToList(newClient: client);

    // Finally we emit the changes, so we can update the UI
    emit(state.copyWith(clients: modifiedClientList));
  }

  // We are either getting the month that is requested otherwise we get the current month
  Future<List<Month?>> getMonths({
    DateTime? selectedMonth,
    DateTime? compareMonth,
    required String clientId,
    required List<Month> savedMonths,
  }) async {
    DateTime currentDate = DateTime.now();

    DateTime month = selectedMonth ?? currentDate;
    DateTime compareMonth =
        selectedMonth ?? DateTime(currentDate.year, currentDate.month - 1);

    String monthId = '${month.year}-${month.month}';
    String compareMonthId = '${compareMonth.year}-${compareMonth.month}';

    List<Month?> reuseSavedMonths = savedMonths
        .where((element) => element.month.month == month.month)
        .toList();

    if (savedMonths.isNotEmpty) {
      return reuseSavedMonths;
    }

    Map<String, dynamic>? monthData =
        await trackerRepository.getClientMonth(monthId, clientId);
    Map<String, dynamic>? compareMonthData =
        await trackerRepository.getClientMonth(compareMonthId, clientId);

    Month? monthModel = Month.convertMonth(monthData, monthId);
    Month? compareMonthModel =
        Month.convertMonth(compareMonthData, compareMonthId);

    return [monthModel, compareMonthModel];
  }

  // Checking if the client already exists in the array, and if so it updates it, otherwise it adds it to the old array.
  List<Client> _addNewClientToList({required Client newClient}) {
    List<Client> newClientList = [];
    newClientList.addAll(state.clients);
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
