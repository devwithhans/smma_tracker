import 'package:agency_time/functions/clients/blocs/edit_client_cubit/edit_client_cubit.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/clients/views/client_view/widgets/custom_app_bar.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/custom_alert_dialog.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditClientView extends StatelessWidget {
  const EditClientView({required this.client, Key? key}) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    Client newClient = client;

    return BlocProvider(
      create: (context) => EditClientCubit(context.read<ClientsRepo>()),
      child: Scaffold(
        body: BlocBuilder<EditClientCubit, EditClientState>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(title: 'Edit ${client.name}'),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      children: [
                        CustomInputForm(
                          initialValue: client.name,
                          title: 'Client name',
                          onChanged: (v) {
                            newClient.name = v;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomInputForm(
                          initialValue: CurrencyTextInputFormatter(
                                  locale: 'da', decimalDigits: 0, symbol: '')
                              .format(
                            client.selectedMonth.hourlyRate.toStringAsFixed(0),
                          ),
                          onChanged: (value) {
                            newClient.selectedMonth.hourlyRate =
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
                        const SizedBox(height: 20),
                        CustomInputForm(
                          initialValue: CurrencyTextInputFormatter(
                                  locale: 'da', decimalDigits: 0, symbol: '')
                              .format(
                                  client.selectedMonth.mrr.toStringAsFixed(0)),
                          onChanged: (value) {
                            newClient.selectedMonth.mrr = value.isNotEmpty
                                ? double.parse(value.replaceAll('.', ''))
                                : 0;
                          },
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter your HRG';
                            }
                          },
                          suffixText: 'DKK',
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                                locale: 'da', decimalDigits: 0, symbol: ''),
                          ],
                          keyboardType: TextInputType.number,
                          title: 'Monthly recurring revenue',
                          hintText: 'Eg. 800 kr.',
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          text: 'Pause client',
                          onPressed: () {},
                          textColor: Colors.black,
                          backgroundColor: kColorYellow,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomElevatedButton(
                              text: 'Save',
                              backgroundColor: kColorGreen,
                              onPressed: () {
                                BlocProvider.of<EditClientCubit>(context)
                                    .editClient(client);
                              },
                            ),
                            CustomTextButton(
                              text: 'Delete',
                              onPressed: () {
                                customAlertDialog(
                                  context: context,
                                  title: 'WARNING',
                                  description:
                                      'When you delete a client, all trackings and statistics connected to this client will be deleted. We recomend you pausing the client if they are no longer active. A client can not be restored after deletion.',
                                  onAccepted: () {},
                                );
                              },
                              textColor: kColorRed,
                              backgroundColor: kColorRed,
                            ),
                          ])),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
