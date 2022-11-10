part of 'login_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends AuthenticationState {}

class LoginLoading extends AuthenticationState {}

class LoginSucces extends AuthenticationState {}

class LoginFailed extends AuthenticationState {
  const LoginFailed({required this.errorMessage, required this.errorCode});
  final String errorMessage;
  final String errorCode;

  @override
  List<Object> get props => [errorMessage, errorCode];
}
