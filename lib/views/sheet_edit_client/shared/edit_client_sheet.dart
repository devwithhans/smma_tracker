import 'package:agency_time/logic/clients/edit_client_cubit/edit_client_cubit.dart';
import 'package:agency_time/logic/clients/new_client_cubit/new_client_cubit.dart';
import 'package:agency_time/logic/clients/repos/client_repo.dart';
import 'package:agency_time/logic/data_visualisation/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/logic/data_visualisation/models/duration_data.dart';
import 'package:agency_time/logic/data_visualisation/models/month.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../features/client/models/client.dart';
import '../../../utils/widgets/buttons/main_button.dart';
import '../../../utils/widgets/buttons/text_button.dart';

class EditClientSheet extends StatelessWidget {
  static String id = 'AddClient';

  EditClientSheet({required this.client, Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final Client client;
  @override
  Widget build(BuildContext context) {
    String name = client.name;
    String description = '';
    double mrr = client.selectedMonth!.totalMrr;
    double hourlyRateTarget = client.selectedMonth!.hourlyRateTarget;

    return BlocProvider(
      create: (context) => EditClientCubit(context.read<ClientsRepo>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit ${client.name}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: BlocBuilder<EditClientCubit, EditClientState>(
          builder: (context, state) {
            if (state is EditClientLoading) {
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
                        CustomTextButton(
                            text: 'Pause client',
                            onPressed: () {
                              context.read<EditClientCubit>().pauseClient(
                                    id: client.id,
                                    mrr: client.selectedMonth!.totalMrr,
                                    pause: true,
                                  );
                            }),
                        CustomTextButton(
                            text: 'Activate client',
                            onPressed: () {
                              context.read<EditClientCubit>().pauseClient(
                                    id: client.id,
                                    mrr: client.selectedMonth!.totalMrr,
                                    pause: false,
                                  );
                            }),
                        client.internal
                            ? Column(
                                children: [
                                  CustomInputForm(
                                    initialValue: name,
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
                                    initialValue: description,
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
                                    initialValue: name,
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
                                    initialValue: CurrencyTextInputFormatter(
                                            locale: 'da',
                                            decimalDigits: 0,
                                            symbol: '')
                                        .format(mrr.toString()),
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
                                    initialValue: CurrencyTextInputFormatter(
                                            locale: 'da',
                                            decimalDigits: 0,
                                            symbol: '')
                                        .format(hourlyRateTarget.toString()),
                                    onChanged: (value) {
                                      hourlyRateTarget = double.parse(
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
                            text: 'Save ${client.name}',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<EditClientCubit>().editClient(
                                      mrr: mrr,
                                      id: client.id,
                                      name: name,
                                      description: description,
                                      hourlyRateTarget: hourlyRateTarget,
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
