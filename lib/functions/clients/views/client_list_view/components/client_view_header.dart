import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  const Header({
    required this.state,
    required this.title,
    required this.onPressed,
    required this.onSelectMonth,
    required this.selectedMonth,
    Key? key,
  }) : super(key: key);
  final void Function()? onSelectMonth;
  final DateTime selectedMonth;
  final ClientsState state;
  final String title;
  final void Function()? onPressed;

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
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.add_circle),
                splashRadius: 20,
              ),
            ],
          ),
          CustomMonthButton(
              icon: Icons.calendar_month,
              onPressed: onSelectMonth,
              text: DateFormat('MMM, y').format(selectedMonth))
        ],
      ),
    );
  }
}
