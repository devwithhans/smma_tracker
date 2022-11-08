part of 'authorization_cubit.dart';

enum AuthStatus {
  signedIn,
  signedOut,
  noCompany,
  initial,
  failed,
}

enum UserRole {
  owner,
  user,
}

class AuthorizationState extends Equatable {
  const AuthorizationState({
    this.authStatus = AuthStatus.initial,
    this.appUser,
    this.company,
    this.invite,
    this.role = UserRole.user,
  });

  final AuthStatus authStatus;
  final AppUser? appUser;
  final Company? company;
  final UserRole role;
  final Invite? invite;

  AuthorizationState copyWith({
    AuthStatus? authStatus,
    AppUser? appUser,
    Company? company,
    UserRole? role,
    Invite? invite,
  }) {
    return AuthorizationState(
        role: role ?? this.role,
        invite: invite ?? this.invite,
        company: company ?? this.company,
        authStatus: authStatus ?? this.authStatus,
        appUser: appUser ?? this.appUser);
  }

  @override
  List<Object> get props => [
        authStatus,
      ];
}
