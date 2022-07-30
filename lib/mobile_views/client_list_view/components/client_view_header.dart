import 'package:agency_time/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/mobile_views/add_clients_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  const Header({
    required this.state,
    Key? key,
  }) : super(key: key);

  final ClientsState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Clients',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddClientView(),
                    ),
                  );
                },
                icon: Icon(Icons.add_circle),
                splashRadius: 20,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                DateFormat('MMMM').format(state.month ?? DateTime.now()),
                style: TextStyle(fontSize: 12),
              ),
              IconButton(
                onPressed: () async {
                  DateTime? selectedDateTime = await showMonthPicker(
                    context: context,
                    initialDate: state.month ?? DateTime.now(),
                  );
                  BlocProvider.of<ClientsBloc>(context).add(GetClientsWithMonth(
                    month: selectedDateTime,
                  ));
                },
                icon: Icon(Icons.calendar_month),
                splashRadius: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}