import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/presentation/signin.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/company/presentation/createCompany.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/views/section_navigation/web/web_navigation_section.dart';
import 'package:agency_time/views/view_no_company/web/web_no_company_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HandleAuthStatus extends StatelessWidget {
  const HandleAuthStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizeCubit, AuthorizeState>(
      builder: ((context, state) {
        if (state.status == BlocStatus.loading) {
          return LoadingScreen();
        }

        if (state.appUser != null) {
          if (state.company != null) {
            return const WebNavigation();
          }
          return const CreateCompany();
        } else {
          return Signin();
        }
      }),
    );
  }
}
