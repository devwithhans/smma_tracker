import 'package:agency_time/functions/app/web_view/web_navigation/web_navigation.dart';
import 'package:agency_time/functions/authentication/views/welcome_view.dart';
import 'package:agency_time/functions/authentication/web_view/web_new_company/web_new_company.dart';
import 'package:agency_time/functions/authentication/web_view/web_no_company.dart';
import 'package:agency_time/functions/authentication/web_view/web_registration.dart';
import 'package:agency_time/functions/authentication/web_view/web_welcome.dart';
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
          return const WebNavigation();
        }
        if (state.authStatus == AuthStatus.signedOut) {
          return WebRegistration();
        }
        if (state.authStatus == AuthStatus.noCompany) {
          return WebNewCompany();
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
