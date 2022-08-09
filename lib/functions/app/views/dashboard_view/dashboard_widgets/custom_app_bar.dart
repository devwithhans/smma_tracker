import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/views/settings_view/settings_view.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/select_month.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required this.onSelectMonth,
    required this.selectedMonth,
    Key? key,
  }) : super(key: key);

  final void Function()? onSelectMonth;
  final DateTime selectedMonth;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
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
