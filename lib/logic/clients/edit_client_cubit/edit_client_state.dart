part of 'edit_client_cubit.dart';

abstract class EditClientState extends Equatable {
  const EditClientState();

  @override
  List<Object> get props => [];
}

class EditClientInitial extends EditClientState {}

class EditClientLoading extends EditClientState {}

class EditClientSucces extends EditClientState {}

class EditClientFailed extends EditClientState {}
