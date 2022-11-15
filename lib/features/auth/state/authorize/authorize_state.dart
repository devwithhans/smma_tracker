part of 'authorize_cubit.dart';

class AuthorizeState extends Equatable {
  const AuthorizeState({
    this.status = BlocStatus.initial,
    this.error,
    this.company,
    this.appUser,
    this.admin = false,
  });
  final BlocStatus status;
  final HcError? error;
  final AppUser? appUser;
  final Company? company;
  final bool admin;

  AuthorizeState copyWith({
    BlocStatus? status,
    HcError? error,
    AppUser? appUser,
    Company? company,
    bool? admin,
  }) {
    return AuthorizeState(
      status: status ?? this.status,
      appUser: appUser ?? this.appUser,
      company: company ?? this.company,
      admin: admin ?? this.admin,
    );
  }

  @override
  List get props => [status, appUser, company, admin];
}
