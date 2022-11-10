part of 'authorize_cubit.dart';

class AuthorizeState extends Equatable {
  const AuthorizeState({
    this.status = BlocStatus.initial,
    this.error,
    this.company,
    this.appUser,
  });
  final BlocStatus status;
  final HcError? error;
  final AppUser? appUser;
  final Company? company;

  AuthorizeState copyWith({
    BlocStatus? status,
    HcError? error,
    AppUser? appUser,
    Company? company,
  }) {
    return AuthorizeState(
      status: status ?? this.status,
      appUser: appUser ?? this.appUser,
      company: company ?? this.company,
    );
  }

  @override
  List get props => [status, appUser, company];
}
