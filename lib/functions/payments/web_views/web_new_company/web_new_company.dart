import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/payments/models/new_company_cubit/new_company_cubit.dart';

import 'package:agency_time/functions/payments/web_views/web_new_company/steps/new_company_steps.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class WebNewCompany extends StatefulWidget {
  static String pageName = 'new_company';

  const WebNewCompany({this.initialStep = 0, Key? key}) : super(key: key);

  final int initialStep;

  @override
  State<WebNewCompany> createState() => _WebNewCompanyState();
}

class _WebNewCompanyState extends State<WebNewCompany> {
  @override
  Widget build(BuildContext context) {
    AuthState authState = context.read<AuthCubit>().state;
    bool hasInvite = authState.invite != null;
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            ManageCompanyCubit(initialStep: widget.initialStep),
        child: ResponsiveSplitScreen(
          left: BlocBuilder<ManageCompanyCubit, ManageCompanyState>(
            builder: (context, state) {
              if (state.newCompanyStatus == NewCompanyStatus) {
                return LoadingScreen();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  state.newCompanyStatus == NewCompanyStatus.loading
                      ? const LoadingScreen()
                      : newCompanySteps[state.step],
                  SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
