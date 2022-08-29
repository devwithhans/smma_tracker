import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomInputStyle { underline, normal }

class CustomInputForm extends StatelessWidget {
  const CustomInputForm({
    this.suffixText,
    this.controller,
    this.autofocus = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.hintMaxLines = 20,
    this.hintText = '',
    this.title = '',
    this.onSaved,
    this.onEditingComplete,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.obscureText = false,
    this.initialValue,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.customInputStyle = CustomInputStyle.normal,
    Key? key,
  }) : super(key: key);
  final CustomInputStyle customInputStyle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final String? initialValue;
  final String hintText;
  final String title;
  final int? maxLines;
  final int? minLines;
  final int hintMaxLines;
  final bool obscureText;
  final void Function(String value)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final String? suffixText;
  final bool autofocus;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isNotEmpty
            ? Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                ],
              )
            : SizedBox(),
        TextFormField(
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          focusNode: focusNode,
          onTap: onTap,
          validator: validator,
          controller: controller,
          minLines: minLines,
          initialValue: initialValue,
          keyboardType: keyboardType,
          autofocus: autofocus,
          maxLines: maxLines,
          onChanged: onChanged,
          textAlign: textAlign,
          onEditingComplete: onEditingComplete,
          onSaved: onSaved,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hoverColor: Colors.transparent,
            suffixText: suffixText,
            contentPadding: customInputStyle == CustomInputStyle.underline
                ? EdgeInsets.all(0)
                : EdgeInsets.all(14),
            filled: true,
            fillColor: customInputStyle == CustomInputStyle.underline
                ? Colors.transparent
                : Color(0xffFCFCFC),
            focusedBorder: customInputStyle == CustomInputStyle.underline
                ? UnderlineInputBorder()
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1),
                  ),
            enabledBorder: customInputStyle == CustomInputStyle.underline
                ? UnderlineInputBorder()
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: Color(0xFFC8C8C8), width: 0.5),
                  ),
            errorBorder: customInputStyle == CustomInputStyle.underline
                ? UnderlineInputBorder()
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.red, width: 0.5),
                  ),
            focusedErrorBorder: customInputStyle == CustomInputStyle.underline
                ? UnderlineInputBorder()
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
            hintMaxLines: hintMaxLines,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
