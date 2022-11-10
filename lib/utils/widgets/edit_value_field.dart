import 'package:flutter/material.dart';

class EditValueField extends StatelessWidget {
  const EditValueField({
    required this.onPressed,
    required this.value,
    required this.title,
    Key? key,
  }) : super(key: key);
  final String value;
  final void Function()? onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              height: 1,
              fontSize: 14,
              // fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.mode_edit_outline_outlined))
          ],
        ),
        Divider(
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}
