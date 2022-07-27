part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucces extends LoginState {}

class LoginFailed extends LoginState {
  const LoginFailed({required this.errorMessage, required this.errorCode});
  final String errorMessage;
  final String errorCode;

  @override
  List<Object> get props => [errorMessage, errorCode];
}
