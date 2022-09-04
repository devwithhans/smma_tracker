import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/views/enter_app_view/web/web_register_user_view.dart';
import 'package:agency_time/views/no_company_view/web/web_no_company_view.dart';
import 'package:agency_time/views/view_folder_template/web/web_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizationCubit, AuthorizationState>(
      builder: ((context, state) {
        print(state.authStatus);
        if (state.authStatus == AuthStatus.signedIn) {
          bool hasActiveSubscription = state.company!.subscription != null &&
              state.company!.roles[state.appUser!.id] == 'owner';

          return WebNavigation(hasActiveSubscription: hasActiveSubscription);
        }
        if (state.authStatus == AuthStatus.signedOut) {
          return WebRegisterView();
        }
        if (state.authStatus == AuthStatus.noCompany) {
          return const WebNoCompany();
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
