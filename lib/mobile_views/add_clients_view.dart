import 'package:agency_time/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/blocs/new_client_cubit/new_client_cubit.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AddClient extends StatelessWidget {
  static String id = 'AddClient';

  AddClient({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? name;
    double? mrr;
    double? hourly_rate_target;
    return BlocProvider(
      create: (context) => NewClientCubit(
          companyId: context.read<AuthCubit>().state.appUser!.companyId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add new client',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: BlocBuilder<NewClientCubit, NewClientState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: ListView(
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
                        SizedBox(height: 30),
                        CustomInputForm(
                          onChanged: (value) {
                            mrr = double.parse(value.replaceAll('.', ''));
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
                          title: 'Monthly recurring revenue',
                          hintText: 'Eg. 15.000 kr.',
                        ),
                        SizedBox(height: 30),
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
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomElevatedButton(
                            text: 'Add Client',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<NewClientCubit>().addClient(
                                      name: name!,
                                      mrr: mrr!,
                                      hourly_rate_target: hourly_rate_target!,
                                    );
                              }
                            },
                          ),
                          // SizedBox(height: 15),
                        ],
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: toCurrencyString(oldValue.text));
  }
}
