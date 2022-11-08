part of 'authenticate_cubit.dart';

class AuthenticateState extends Equatable {
  const AuthenticateState({this.status = Status.initial, this.error});

  final Status status;
  final HcError? error;

  AuthenticateState copyWith({Status? status, HcError? error}) {
    return AuthenticateState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List get props => [status, error];
}
