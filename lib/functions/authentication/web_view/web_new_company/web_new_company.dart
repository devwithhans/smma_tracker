import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/blocs/new_company_cubit/new_company_cubit.dart';
import 'package:agency_time/functions/authentication/web_view/web_new_company/steps/new_company_steps.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class WebNewCompany extends StatefulWidget {
  static String pageName = 'new_company';

  const WebNewCompany({Key? key}) : super(key: key);

  @override
  State<WebNewCompany> createState() => _WebNewCompanyState();
}

class _WebNewCompanyState extends State<WebNewCompany> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthState authState = context.read<AuthCubit>().state;
    bool hasInvite = authState.invite != null;
    return Scaffold(
      body: BlocProvider(
        create: (context) => NewCompanyCubit(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 1000, maxWidth: 600),
              child: BlocBuilder<NewCompanyCubit, NewCompanyState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        newCompanySteps[state.step],
                        SizedBox(height: 40),
                        CustomElevatedButton(
                            text: 'Next',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<NewCompanyCubit>()
                                    .createCompany(authState.appUser!.id);
                              }
                            })
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
