import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/blocs/new_client_cubit/new_client_cubit.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AddClientView extends StatelessWidget {
  static String id = 'AddClient';

  AddClientView({this.internal = false, Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final bool internal;
  @override
  Widget build(BuildContext context) {
    String? name;
    String? description;
    double? mrr;
    double? hourly_rate_target;

    return BlocProvider(
      create: (context) => NewClientCubit(
          companyId: context.read<AuthCubit>().state.appUser!.companyId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add new ${internal ? 'internal' : 'client'}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: BlocBuilder<NewClientCubit, NewClientState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(
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
                        internal
                            ? Column(
                                children: [
                                  CustomInputForm(
                                    onChanged: (v) {
                                      name = v;
                                    },
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Please enter a title';
                                      }
                                    },
                                    title: 'Internal title',
                                    hintText:
                                        'Name the internal job you wanna track',
                                  ),
                                  SizedBox(height: 30),
                                  CustomInputForm(
                                    maxLines: 4,
                                    onChanged: (v) {
                                      description = v;
                                    },
                                    title: 'Description (optional)',
                                    hintText: 'Description',
                                  ),
                                ],
                              )
                            : Column(
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
                                      mrr = value.isNotEmpty
                                          ? double.parse(
                                              value.replaceAll('.', ''))
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
                                          locale: 'da',
                                          decimalDigits: 0,
                                          symbol: ''),
                                    ],
                                    keyboardType: TextInputType.number,
                                    title: 'MRR',
                                    hintText: 'Eg. 15.000 kr.',
                                  ),
                                  SizedBox(height: 30),
                                  CustomInputForm(
                                    onChanged: (value) {
                                      hourly_rate_target = double.parse(
                                          value.replaceAll('.', ''));
                                    },
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Please enter your HRG';
                                      }
                                    },
                                    suffixText: 'DKK/h',
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                          locale: 'da',
                                          decimalDigits: 0,
                                          symbol: ''),
                                    ],
                                    keyboardType: TextInputType.number,
                                    title: 'Hourly rate goal',
                                    hintText: 'Eg. 800 kr.',
                                  ),
                                ],
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
                            text: 'Add ${internal ? 'task' : 'client'}',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<NewClientCubit>().addClient(
                                      name: name!,
                                      description: description,
                                      mrr: mrr,
                                      internal: internal,
                                      hourly_rate_target: hourly_rate_target,
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
