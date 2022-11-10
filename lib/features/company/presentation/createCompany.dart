import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/company/state/cubit/create_company_cubit.dart';
import 'package:agency_time/logic/authentication/new_company_cubit/new_company_cubit.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/utils/constants/currencies.dart';
import 'package:agency_time/utils/constants/spacings.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/constants/validators.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/utils/widgets/buttons/text_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:agency_time/views/view_register_company/web/widgets/company_details.dart';
import 'package:agency_time/views/view_register_company/web/widgets/select_currency_dropdown.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCompany extends StatefulWidget {
  static String pageName = 'register-company';

  const CreateCompany({Key? key}) : super(key: key);

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthorizeState authState = context.read<AuthorizeCubit>().state;

    String? name;
    String? vatNumber;
    String? currency;

    return Scaffold(
      body: BlocProvider(
        create: (context) => CreateCompanyCubit(),
        child: ResponsiveSplitScreen(
          left: BlocBuilder<CreateCompanyCubit, CreateCompanyState>(
            builder: (context, state) {
              if (state.status == BlocStatus.loading) {
                return const LoadingScreen();
              }
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Let\'s set up your company',
                      style: AppTextStyle.boldLarge,
                    ),
                    xtraLargeY,
                    CustomInputForm(
                      title: 'Company name',
                      hintText: 'Company name',
                      maxLines: 1,
                      onChanged: (v) {
                        name = v;
                      },
                      validator: AppValidator.validateName,
                    ),
                    xtraLargeY,
                    CustomInputForm(
                      title: 'VAT number (Optional)',
                      hintText: 'VAT number (Optional)',
                      onChanged: (v) {
                        vatNumber = v;
                      },
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                    xtraLargeY,
                    DropDownSearch(
                      currencies: currencies
                          .map((e) => Currency.from(json: e))
                          .toList(),
                      onChange: ((v) => currency = v),
                    ),
                    xtraLargeY,
                    CustomElevatedButton(
                        text: 'Next',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<CreateCompanyCubit>().createCompany(
                                  name: name!,
                                  vatNumber: vatNumber,
                                  userId: authState.appUser!.id,
                                  countryCode: currency!,
                                );
                          }
                        }),
                    CustomTextButton(
                        text: ('SIGNOUT'),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
