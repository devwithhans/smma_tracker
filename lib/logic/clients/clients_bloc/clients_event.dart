part of 'clients_bloc.dart';

abstract class ClientsEvent extends Equatable {
  const ClientsEvent();
  @override
  List<Object?> get props => [];
}

class GetClientsWithMonth extends ClientsEvent {
  final DateTime? month;
  final DateTime? compareMonth;
  const GetClientsWithMonth({this.compareMonth, this.month});
}

class AddClient extends ClientsEvent {
  final QueryDocumentSnapshot<Map<String, dynamic>> client;

  const AddClient({required this.client});
}

class OfflineMonthUpdate extends ClientsEvent {
  final Duration duration;
  final String clientId;

  const OfflineMonthUpdate({required this.duration, required this.clientId});
}
