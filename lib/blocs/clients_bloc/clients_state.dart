part of 'clients_bloc.dart';

enum Status { loading, initial, succes, failed }

class ClientsState extends Equatable {
  const ClientsState({
    this.status = Status.initial,
    this.clients = const [],
    this.month,
    this.compareMonth,
  });

  final DateTime? month;
  final DateTime? compareMonth;

  final Status status;

  final List<Client> clients;

  ClientsState copyWith({
    List<Client>? clients,
    Status? status,
    DateTime? month,
    DateTime? compareMonth,
  }) {
    return ClientsState(
        status: status ?? this.status,
        clients: clients ?? this.clients,
        month: month ?? this.month,
        compareMonth: compareMonth ?? this.compareMonth);
  }

  @override
  List get props => [clients, status, month, compareMonth];
}
