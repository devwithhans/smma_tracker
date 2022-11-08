import 'package:agency_time/features/auth/presentation/signin.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/views/section_navigation/web/web_navigation_section.dart';
import 'package:agency_time/views/view_no_company/web/web_no_company_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizeCubit, AuthorizeState>(
      builder: ((context, state) {
        if (state.appUser != null) {
          if (state.company != null) {
            return WebNavigation();
          }
          return const WebNoCompany();
        }

        return Signin();
      }),
    );
  }
}
