part of 'get_clients_cubit_cubit.dart';

class GetClientsState extends Equatable {
  const GetClientsState({
    this.status = BlocStatus.initial,
    this.error,
    this.allClients = const [],
    this.allInternals,
    this.myClients,
    this.myInternals,
    this.result,
  });
  final BlocStatus status;
  final HcError? error;
  final List<Client> allClients;
  final List<Client>? allInternals;
  final List<Client>? myClients;
  final List<Client>? myInternals;
  final List<Client>? result;

  GetClientsState copyWith({
    BlocStatus? status,
    HcError? error,
    List<Client>? allClients,
    List<Client>? allInternals,
    List<Client>? myClients,
    List<Client>? myInternals,
    List<Client>? result,
  }) {
    return GetClientsState(
      status: status ?? this.status,
      allClients: allClients ?? this.allClients,
      allInternals: allInternals ?? this.allInternals,
      myClients: myClients ?? this.myClients,
      myInternals: myInternals ?? this.myInternals,
      result: result ?? this.result,
    );
  }

  @override
  List get props => [status, allClients, allInternals, myClients, myInternals];
}
