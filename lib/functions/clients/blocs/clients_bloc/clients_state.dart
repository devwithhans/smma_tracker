part of 'clients_bloc.dart';

enum Status { loading, initial, succes, failed }

class ClientsState extends Equatable {
  const ClientsState({
    this.status = Status.initial,
    this.allClients = const [],
    this.clients = const [],
    this.internals = const [],
    this.month,
    this.compareMonth,
  });

  final DateTime? month;
  final DateTime? compareMonth;

  final Status status;

  final List<Client> allClients;
  final List<Client> clients;
  final List<Client> internals;

  ClientsState copyWith({
    List<Client>? allClients,
    List<Client>? clients,
    List<Client>? internals,
    Status? status,
    DateTime? month,
    DateTime? compareMonth,
  }) {
    return ClientsState(
        status: status ?? this.status,
        allClients: allClients ?? this.allClients,
        clients: clients ?? this.clients,
        internals: internals ?? this.internals,
        month: month ?? this.month,
        compareMonth: compareMonth ?? this.compareMonth);
  }

  @override
  List get props =>
      [clients, status, month, compareMonth, allClients, internals];
}
