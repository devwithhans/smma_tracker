import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/logic/clients/new_client_cubit/new_client_cubit.dart';
import 'package:agency_time/logic/data_visualisation/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: toCurrencyString(oldValue.text));
  }
}

void addClient(context) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.1),
    context: context,
    builder: (context) => Dialog(child: NewClient()),
  );
}

class NewClient extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String? name;
    String? description;
    double? mrr;
    double? hourly_rate_target;

    return BlocProvider(
      create: (context) => NewClientCubit(
          companyId: context.read<AuthorizeCubit>().state.appUser!.companyId!),
      child: BlocBuilder<NewClientCubit, NewClientState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SizedBox(
              height: 600,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 20),
                        child: Text(
                          'Add new client',
                          style: AppTextStyle.boldMedium,
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomInputForm(
                              onChanged: (v) {
                                name = v;
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter a name';
                                }
                              },
                              title: 'Client name',
                              hintText: 'Eg. Brun & Bøge ApS',
                            ),
                            const SizedBox(height: 30),
                            CustomInputForm(
                              onChanged: (value) {
                                mrr = value.isNotEmpty
                                    ? double.parse(value.replaceAll('.', ''))
                                    : 0;
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter the MRR';
                                }
                              },
                              suffixText: 'DKK',
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                    locale: 'da', decimalDigits: 0, symbol: ''),
                              ],
                              keyboardType: TextInputType.number,
                              title: 'MRR',
                              hintText: 'Eg. 15.000 kr.',
                            ),
                            const SizedBox(height: 30),
                            CustomInputForm(
                              onChanged: (value) {
                                hourly_rate_target =
                                    double.parse(value.replaceAll('.', ''));
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter your HRG';
                                }
                              },
                              suffixText: 'DKK/h',
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                    locale: 'da', decimalDigits: 0, symbol: ''),
                              ],
                              keyboardType: TextInputType.number,
                              title: 'Hourly rate goal',
                              hintText: 'Eg. 800 kr.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                backgroundColor: Colors.grey.shade200,
                                textColor: kColorRed,
                                border: false,
                                text: 'Cancel',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomElevatedButton(
                                text: 'Add client',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<NewClientCubit>(context)
                                        .addClient(
                                      name: name!,
                                      description: description,
                                      mrr: mrr,
                                      internal: false,
                                      hourly_rate_target: hourly_rate_target,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
