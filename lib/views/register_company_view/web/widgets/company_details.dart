import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/payments/models/new_company_cubit/new_company_cubit.dart';

import 'package:agency_time/utils/constants/currencies.dart';
import 'package:agency_time/utils/constants/spacings.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/constants/validators.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/views/register_company_view/web/widgets/select_currency_dropdown.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyDetail extends StatelessWidget {
  const CompanyDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthState authState = context.read<AuthCubit>().state;

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
              context.read<ManageCompanyCubit>().updateValues(companyName: v);
            },
            validator: AppValidator.validateName,
          ),
          xtraLargeY,
          CustomInputForm(
            title: 'VAT number (Optional)',
            hintText: 'VAT number (Optional)',
            onChanged: (v) {
              context.read<ManageCompanyCubit>().updateValues(vatNumber: v);
            },
            keyboardType: TextInputType.number,
            maxLines: 1,
          ),
          xtraLargeY,
          DropDownSearch(
            currencies: currencies.map((e) => Currency.from(json: e)).toList(),
            onChange: ((v) => context
                .read<ManageCompanyCubit>()
                .updateValues(countryCode: v)),
          ),
          xtraLargeY,
          CustomElevatedButton(
              text: 'Next',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context
                      .read<ManageCompanyCubit>()
                      .createCompany(authState.appUser!.id);
                }
              })
        ],
      ),
    );
  }
}
