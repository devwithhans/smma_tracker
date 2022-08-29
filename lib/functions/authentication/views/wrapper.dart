import 'package:agency_time/functions/authentication/web_view/web_registration.dart';
import 'package:agency_time/functions/payments/web_views/web_new_company/web_new_company.dart';
import 'package:agency_time/functions/statistics/web_view/web_navigation/web_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../blocs/auth_cubit/auth_cubit.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: ((context, state) {
        if (state.authStatus == AuthStatus.signedIn) {
          if (state.company!.subscription == null &&
              state.company!.roles[state.appUser!.id] == 'owner') {
            return const WebNewCompany(
              initialStep: 1,
            );
          }

          return const WebNavigation();
        }
        if (state.authStatus == AuthStatus.signedOut) {
          return WebRegistration();
        }
        if (state.authStatus == AuthStatus.noCompany) {
          return const WebNewCompany();
        }
        return Scaffold(
          body: Center(
            child: LottieBuilder.asset(
              'assets/lottie.json',
              repeat: false,
            ),
          ),
        );
      }),
    );
  }
}
