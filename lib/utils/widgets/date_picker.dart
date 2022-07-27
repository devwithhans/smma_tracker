import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final Function(DateTime value) onSelect;
  final DateTime? value;
  final String hintText;
  final String title;

  const CustomDatePicker({
    required this.hintText,
    required this.title,
    this.value,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? _startDate;
    return CustomInputForm(
      controller: TextEditingController(
        text: value == null ? null : DateFormat('EEE, dd MMM ').format(value!),
      ),
      onTap: () async {
        _startDate = await showDatePicker(
          locale: const Locale('da'),
          context: context,
          initialDate: value ?? DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.black, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.black, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          helpText: 'Vælg en dato',
          confirmText: 'VÆLG',
          cancelText: 'ANNULER',
          fieldLabelText: 'Vælg dato',
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (_startDate != null) {
          onSelect(_startDate!);
        }
      },
      title: title,
      hintText: hintText,
      onChanged: (v) {},
      validator: (v) {
        return null;
      },
    );
  }
}
