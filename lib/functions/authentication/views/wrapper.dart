import 'package:agency_time/functions/app/views/bottom_navigation.dart';
import 'package:agency_time/functions/authentication/views/welcome_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';

import '../blocs/auth_cubit/auth_cubit.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: ((context, state) {
        if (state.authStatus == AuthStatus.signedIn) {
          return const BottomNav();
        }
        if (state.authStatus == AuthStatus.signedOut) {
          return WelcomeView();
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
