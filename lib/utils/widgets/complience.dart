import 'package:flutter/material.dart';

class Compliance extends StatefulWidget {
  final bool initialValue;
  final Function(bool v) onChange;
  final String? Function(bool? v) validator;
  final String text;
  final String errorText;
  final bool showError;
  final String? buttonText;
  final Function()? onTextButton;

  const Compliance({
    Key? key,
    required this.validator,
    this.errorText = '',
    this.buttonText,
    this.onTextButton,
    this.initialValue = false,
    required this.onChange,
    this.text = '',
    this.showError = false,
  }) : super(key: key);

  @override
  State<Compliance> createState() => _ComplianceState();
}

class _ComplianceState extends State<Compliance> {
  late bool termsAccept;

  @override
  void initState() {
    super.initState();
    termsAccept = widget.initialValue;
  }

  void _onChange(v) {
    widget.onChange(v);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: termsAccept,
      validator: widget.validator,
      builder: (state) => GestureDetector(
        onTap: () {
          termsAccept = !termsAccept;

          // ignore: invalid_use_of_protected_member
          state.setValue(termsAccept);
          _onChange(termsAccept);
          setState(() {});
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          // height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                        activeColor: Colors.black,
                        side: const BorderSide(width: 1),
                        value: termsAccept,
                        splashRadius: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        onChanged: (v) {
                          termsAccept = !termsAccept;
                          // ignore: invalid_use_of_protected_member
                          state.setValue(termsAccept);
                          _onChange(termsAccept);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.text,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  widget.buttonText != null
                      ? TextButton(
                          onPressed: widget.onTextButton,
                          child: Text(
                            widget.buttonText ?? '',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ))
                      : SizedBox(),
                ],
              ),
              Visibility(
                visible: state.hasError,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    state.errorText ?? '',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
