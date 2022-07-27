import 'package:flutter/material.dart';

class MonthModal extends StatelessWidget {
  const MonthModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'This month',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
        ),
        Icon(Icons.arrow_drop_down),
      ],
    );
  }
}
