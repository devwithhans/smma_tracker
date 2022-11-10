import 'package:agency_time/features/auth/presentation/signin.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/main.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/views/section_navigation/web/web_navigation_section.dart';
import 'package:agency_time/views/view_enter_app/web/web_register_user_view.dart';
import 'package:agency_time/views/view_no_company/web/web_no_company_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
          // return WebNavigation(hasActiveSubscription: hasActiveSubscription);
          return WebNavigation();
        }
        if (state.authStatus == AuthStatus.signedOut) {
          return Signin();
        }
        if (state.authStatus == AuthStatus.noCompany) {
          return const WebNoCompany();
        }
        return Scaffold(
          body: Center(
              child: Column(
            children: [
              Text('something went wrong'),
              CustomElevatedButton(
                  text: 'LOGOUT',
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  })
            ],
          )),
        );
      }),
    );
  }
}
