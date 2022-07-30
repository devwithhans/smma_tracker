part of 'clients_bloc.dart';

abstract class ClientsEvent extends Equatable {
  const ClientsEvent({this.compareMonth, this.month});

  final DateTime? month;
  final DateTime? compareMonth;

  @override
  List<Object?> get props => [compareMonth, month];
}

class AddClient extends ClientsEvent {
  final QueryDocumentSnapshot<Map<String, dynamic>> client;

  const AddClient({required this.client});
}
