import 'dart:async';
import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/models/error.dart';
import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/repository/authenticate_repo.dart';
import 'package:agency_time/features/auth/repository/authorize_repo.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authorize_state.dart';

class AuthorizeCubit extends Cubit<AuthorizeState> {
  late StreamSubscription<User?> authStream;
  AuthorizeRepo authorizeRepo = AuthorizeRepo();
  AuthenticateRepo authenticateRepo = AuthenticateRepo();

  AuthorizeCubit() : super(AuthorizeInitial()) {
    authStream =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _handleSignedInUser(user).catchError((e) {
          emit(state.copyWith(
              status: BlocStatus.failed,
              error: HcError.errorConnectingToTheServer));
        });
      } else {
        emit(state.copyWith(status: BlocStatus.initial));
      }
    });
  }
  Future<void> _handleSignedInUser(User user) async {
    AppUser? appUser = await authorizeRepo.getAppUser(user.uid);

    if (appUser == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.getRedirectResult();
      if (userCredential.user == null) {
        FirebaseAuth.instance.signOut();
        emit(state.copyWith(status: BlocStatus.initial));
      }
      await authenticateRepo.createUserWithOauth(user);
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);

      print(userCredential.user!.uid);
    }
    Company? company = await authorizeRepo.getCompany(appUser!.id);

    if (company == null) {
      emit(state.copyWith(
        appUser: appUser,
      ));
      return;
    }

    emit(
      state.copyWith(
        appUser: appUser,
        company: company,
      ),
    );
  }
}
