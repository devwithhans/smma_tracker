import 'package:agency_time/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    Key? key,
    this.hintText = '',
    this.initalValue = '',
    required this.onSearch,
  }) : super(key: key);
  final String initalValue;
  final void Function(String value) onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      onChanged: onSearch,
      cursorColor: kColorGreyText,
      initialValue: initalValue,
      style: const TextStyle(
        fontSize: 15.0,
      ),
      // cursorHeight: 15,
      decoration: InputDecoration(
        // isDense: true,
        // contentPadding: const EdgeInsets.symmetric(vertical: .0),

        isDense: true, // Added this
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: SizedBox(
            width: 30,
            child: Icon(
              Icons.search,
              color: kColorGreyText,
              size: 20,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(maxHeight: 20),

        filled: true,
        fillColor: const Color(0xffFCFCFC),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: kColorGreyText, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: kColorGreyText, width: 0.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red, width: 0.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        hintText: hintText,
      ),
    );
  }
}
