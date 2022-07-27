part of 'auth_cubit.dart';

enum AuthStatus { signedIn, signedOut, initial, failed, noCompany }

class AuthState extends Equatable {
  const AuthState(
      {this.authStatus = AuthStatus.initial, this.appUser, this.company});

  final AuthStatus authStatus;
  final AppUser? appUser;
  final Company? company;

  AuthState copyWith(
      {AuthStatus? authStatus, AppUser? appUser, Company? company}) {
    return AuthState(
        company: company ?? this.company,
        authStatus: authStatus ?? this.authStatus,
        appUser: appUser ?? this.appUser);
  }

  @override
  List<Object> get props => [authStatus];
}
