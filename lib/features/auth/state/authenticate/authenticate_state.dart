part of 'authenticate_cubit.dart';

class AuthenticateState extends Equatable {
  const AuthenticateState({this.status = BlocStatus.initial, this.error});

  final BlocStatus status;
  final HcError? error;

  AuthenticateState copyWith({BlocStatus? status, HcError? error}) {
    return AuthenticateState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List get props => [status, error];
}
