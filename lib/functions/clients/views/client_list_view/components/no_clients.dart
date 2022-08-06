import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class NoClients extends StatelessWidget {
  const NoClients({
    Key? key,
    required this.currentMonth,
    required this.state,
  }) : super(key: key);

  final ClientsState state;

  final bool currentMonth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentMonth
              ? 'You dont have any client '
              : 'You had no clients in ${DateFormat('MMMM').format(state.month!)}',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: double.infinity,
          height: 20,
        ),
        currentMonth
            ? CustomElevatedButton(
                text: 'Add Client',
                onPressed: () {
                  Navigator.pushNamed(context, AddClientView.id);
                },
              )
            : CustomElevatedButton(
                text: 'Change month',
                onPressed: () async {
                  DateTime? selectedDateTime = await showMonthPicker(
                    lastDate: DateTime.now(),
                    context: context,
                    initialDate: state.month ?? DateTime.now(),
                  );
                  BlocProvider.of<ClientsBloc>(context).add(GetClientsWithMonth(
                    month: selectedDateTime,
                  ));
                },
              )
      ],
    );
  }
}
