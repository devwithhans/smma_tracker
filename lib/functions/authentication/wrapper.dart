import 'package:agency_time/functions/app/views/bottom_navigation.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/views/welcome_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: ((context, state) {
        // return ErrorScreen(
        //   appError: AppErrors.noConnection,
        // );
        if (state.authStatus == AuthStatus.signedIn) {
          return const BottomNav();
          // const BottomNav();
        }
        if (state.authStatus == AuthStatus.signedOut) {
          return WelcomeView();
        }
        if (state.authStatus == AuthStatus.noCompany) {
          return Center(
            child: Text('We could not assign any company'),
          );
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
