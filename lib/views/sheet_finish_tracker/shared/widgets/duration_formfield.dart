import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationFormField extends StatelessWidget {
  DurationFormField({
    required this.onChanged,
    required this.initialDuration,
    Key? key,
  }) : super(key: key);

  final void Function(Duration) onChanged;
  final Duration initialDuration;

  @override
  Widget build(BuildContext context) {
    Duration result = initialDuration;

    final List<String> duration = _getDurationHMS(result);

    String _seconds = duration[2];
    String _minutes = duration[1];
    String _hours = duration[0];

    TextEditingController secondsController =
        TextEditingController(text: _seconds.toString());
    FocusNode secondsFocusNode = FocusNode();

    TextEditingController minutesController =
        TextEditingController(text: _minutes.toString());
    FocusNode minutesFocusNode = FocusNode();

    TextEditingController hoursController =
        TextEditingController(text: _hours.toString());
    FocusNode hoursFocusNode = FocusNode();

    Duration changeResultDuration() {
      result = Duration(
        hours: int.parse(_hours),
        seconds: int.parse(_seconds),
        minutes: int.parse(_minutes),
      );
      return result;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberInputField(
          formatter: false,
          controller: hoursController,
          focusNode: hoursFocusNode,
          onChanged: (v) {
            _hours = v;
            onChanged(changeResultDuration());
          },
          onTap: () => hoursController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: hoursController.value.text.length,
          ),
        ),
        Text(
          ':',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
        ),
        NumberInputField(
          controller: minutesController,
          focusNode: minutesFocusNode,
          onChanged: (v) {
            _minutes = v;
            onChanged(changeResultDuration());
          },
          onTap: () => minutesController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: minutesController.value.text.length,
          ),
        ),
        Text(
          ':',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
        ),
        NumberInputField(
          controller: secondsController,
          focusNode: secondsFocusNode,
          onChanged: (v) {
            _seconds = v;
            onChanged(changeResultDuration());
          },
          onTap: () => secondsController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: secondsController.value.text.length,
          ),
        ),
      ],
    );
  }

  List<String> _getDurationHMS(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [twoDigits(duration.inHours), twoDigitMinutes, twoDigitSeconds];
  }
}

String twoDigits(int n) => n.toString().padLeft(2, "0");

class NumberInputField extends StatefulWidget {
  NumberInputField({
    required this.focusNode,
    required this.onTap,
    required this.controller,
    required this.onChanged,
    this.formatter = true,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final TextEditingController controller;
  final FocusNode focusNode;
  void Function(String) onChanged;
  final bool formatter;

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 55,
      child: Center(
        child: TextField(
          maxLength: 2,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          showCursor: false,
          controller: widget.controller,
          inputFormatters: widget.formatter
              ? [TimeInputFormatter(), TwoDigitsFormatter()]
              : [TwoDigitsFormatter()],
          onChanged: (v) {
            widget.onChanged(v);
            if (v.isEmpty) {
              widget.controller.text = '00';
            }
          },
          onTap: widget.onTap,
          textAlign: TextAlign.center,
          selectionHeightStyle: BoxHeightStyle.max,
          selectionWidthStyle: BoxWidthStyle.max,
          enableInteractiveSelection: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 40,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            counterText: '',
            hintText: '00',
          ),
        ),
      ),
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (int.parse(newValue.text) > 59) {
      return newValue.copyWith(
          text: '59', selection: new TextSelection.collapsed(offset: 1));
    }
    return newValue.copyWith(
      text: newValue.text,
      selection: TextSelection.collapsed(offset: 2),
    );
  }
}

class TwoDigitsFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: twoDigits(int.parse(newValue.text)),
      selection: TextSelection.collapsed(offset: 2),
    );
  }
}
