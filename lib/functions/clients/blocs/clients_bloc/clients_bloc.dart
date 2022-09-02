import 'dart:async';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/month.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
      for (var clientRaw in event.docs) {
        add(AddClient(client: clientRaw));
      }
      add(const GetClientsWithMonth());
    });

    on<AddClient>(_addClient);
    on<GetClientsWithMonth>(_setClientMonth);
    on<OfflineMonthUpdate>(_offlineMonthUpdate);

    @override
    Future<void> close() {
      _clientsStream.cancel();
      return super.close();
    }
  }

  _offlineMonthUpdate(OfflineMonthUpdate event, Emitter emit) {
    /// WHAT TO UPDATE:
    /// - Update the client total
    /// - Update the client employee

    String userId = clientsRepo.authCubit.state.appUser!.id;

    // Get all clients:
    List<Client> newClientList = [];
    newClientList.addAll(state.clients);

    // We recieve the client who's data we need to update
    List<Client> clientToUpdateList =
        newClientList.where((element) => element.id == event.clientId).toList();
    // We return if it does not exists
    if (clientToUpdateList.isEmpty) {
      return;
    }

    // We revieve just the client from the single-item array
    Client client = clientToUpdateList.last;

    //
    Month selectedMonth = client.selectedMonth!;

    selectedMonth.employees
        .firstWhere((element) => element.member.id == userId)
        .totalDuration += event.duration;

    selectedMonth.duration += event.duration;

    newClientList
        .firstWhere((element) => element.id == event.clientId)
        .selectedMonth = selectedMonth;
    emit(state.copyWith(clients: newClientList, status: Status.loading));
    emit(state.copyWith(status: Status.initial));
  }

  // Selecting the months
  Future<void> _setClientMonth(GetClientsWithMonth event, Emitter emit) async {
    List<Client> updatedClients =
        []; // The list of updated clients to be emitted

    for (var client in state.clients) {
      DateTime selectedDate = event.month ?? state.month ?? DateTime.now();
      // We start by setting the date of selected month. If we havent added any it will be current month

      // We filter the array to check if we got the month
      List selectedMonthList = client.savedMonths
          .where((element) => element.date.month == selectedDate.month)
          .toList();

      // If the array is empty it means we have no matching Month saved in the client doc
      if (selectedMonthList.isEmpty) {
        // We set the client to active month false.

        Month newMonth = Month(
            date: DateTime.now(),
            updatedAt: DateTime.now(),
            mrr: client.savedMonths.first.mrr,
            hourlyRateTarget: client.savedMonths.first.hourlyRateTarget);

        updatedClients.add(client.copyWith(
          selectedMonth: newMonth,
        ));

        // await clientsRepo.setClientMonth(newMonth, client.id);
      } else {
        // We declare the found month to selected month
        Month selectedMonth = selectedMonthList.first;

        // We check if we have a specific compare date, otherwise we set it to previus month relativ to selected month.
        DateTime compareDate = event.compareMonth ??
            DateTime(selectedMonth.date.year, selectedMonth.date.month - 1);

        // We filter a list to check if we got the compareMonth
        List<Month> compareMonthList = client.savedMonths
            .where((element) => element.date.month == compareDate.month)
            .toList();

        Month? compareMonth =
            compareMonthList.isNotEmpty ? compareMonthList.last : null;
        if (selectedMonth == null) {
          updatedClients.add(client.copyWith(activeMonth: false));
          break;
        }
        updatedClients.add(client.copyWith(
          selectedMonth: selectedMonth,
          compareMonth: compareMonth,
          activeMonth: true,
        ));
      }
    }
    emit(state.copyWith(clients: updatedClients, month: event.month));
  }

  Future<void> _addClient(AddClient event, Emitter emit) async {
    Map<String, dynamic> clientMap = event.client.data();
    Map<String, dynamic> monthsMap = clientMap['months'] ?? {};
    List<Month> savedMonths = [];
    monthsMap.forEach((key, value) {
      Month? month = Month.convertMonth(value, key, company);
      if (month != null) {
        savedMonths.add(month);
      }
    });
    Month selectedMonth = savedMonths[0];
    Month? compareMonth = savedMonths.length < 2 ? null : savedMonths[1];

    Client client = Client(
      internal: clientMap['internal'] ?? false,
      id: event.client.id,
      name: clientMap['name'],
      savedMonths: savedMonths,
      updatedAt: clientMap['updatedAt'],
      compareMonth: savedMonths.length < 2 ? null : savedMonths[1],
      selectedMonth: savedMonths[0],
      hourlyRateChange: getChangeProcentage(selectedMonth.hourlyRate,
          compareMonth != null ? compareMonth.hourlyRate : 0),
      durationChange: compareMonth == null
          ? selectedMonth.duration
          : selectedMonth.duration - compareMonth.duration,
    );

    // We modify the list, updates if the client exists and adds if it does not exist
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
      List<Client> filtered = modifiedClientList
          .where((element) => element.internal == false)
          .toList();
      clients.addAll(filtered);
    } catch (e) {}

    // Finally we emit the changes, so we can update the UI'

    emit(
      state.copyWith(
          clients: clients,
          internalClients: internals,
          allClients: modifiedClientList),
    );
  }

  // We are either getting the month that is requested otherwise we get the current month
  Future<List<Month?>> getMonths({
    DateTime? selectedMonth,
    DateTime? compareMonth,
    required String clientId,
    required List<Month> savedMonths,
  }) async {
    DateTime month = selectedMonth ?? DateTime.now();
    DateTime compareMonth =
        selectedMonth ?? DateTime(month.year, month.month - 1);

    String monthId = '${month.year}-${month.month}';
    String compareMonthId = '${compareMonth.year}-${compareMonth.month}';

    List<Month?> reuseSavedMonths = savedMonths
        .where((element) => element.date.month == month.month)
        .toList();

    if (savedMonths.isNotEmpty) {
      return reuseSavedMonths;
    }

    Map<String, dynamic>? monthData =
        await clientsRepo.getClientMonth(monthId, clientId);
    Map<String, dynamic>? compareMonthData =
        await clientsRepo.getClientMonth(compareMonthId, clientId);

    Month? monthModel = Month.convertMonth(monthData, monthId, company);
    Month? compareMonthModel =
        Month.convertMonth(compareMonthData, compareMonthId, company);

    return [monthModel, compareMonthModel];
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
