part of 'clients_bloc.dart';

enum Status { loading, initial, succes, failed }

class ClientsState extends Equatable {
  const ClientsState({
    this.status = Status.initial,
    this.clients = const [],
  });

  final Status status;

  final List<Client> clients;

  ClientsState copyWith({
    List<Client>? clients,
    Status? status,
  }) {
    return ClientsState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
    );
  }

  @override
  List get props => [clients, status];
}
