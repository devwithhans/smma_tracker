part of 'clients_cubit.dart';

enum Status { loading, initial, succes, failed }

class ClientsState extends Equatable {
  const ClientsState({
    this.status = Status.initial,
    required this.thisMonth,
    required this.lastMonth,
    this.clients = const [],
  });

  final Status status;

  final Month thisMonth;
  final Month lastMonth;
  final List<Client> clients;

  ClientsState copyWith({
    List<Client>? clients,
    Month? thisMonth,
    Month? lastMonth,
    Status? status,
  }) {
    return ClientsState(
      thisMonth: thisMonth ?? this.thisMonth,
      lastMonth: lastMonth ?? this.lastMonth,
      status: status ?? this.status,
      clients: clients ?? this.clients,
    );
  }

  @override
  List get props => [clients, status, thisMonth, lastMonth];
}
