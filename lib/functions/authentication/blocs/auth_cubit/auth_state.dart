part of 'auth_cubit.dart';

enum AuthStatus {
  signedIn,
  signedOut,
  initial,
  failed,
  noCompany,
}

class AuthState extends Equatable {
  const AuthState({
    this.authStatus = AuthStatus.initial,
    this.appUser,
    this.company,
    this.invite,
    this.role,
  });

  final AuthStatus authStatus;
  final AppUser? appUser;
  final Company? company;
  final String? role;
  final Invite? invite;

  AuthState copyWith({
    AuthStatus? authStatus,
    AppUser? appUser,
    Company? company,
    String? role,
    Invite? invite,
  }) {
    return AuthState(
        role: role ?? this.role,
        invite: invite ?? this.invite,
        company: company ?? this.company,
        authStatus: authStatus ?? this.authStatus,
        appUser: appUser ?? this.appUser);
  }

  @override
  List<Object> get props => [authStatus];
}
