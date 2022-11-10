import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> customAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required void Function()? onAccepted,
}) {
  return showDialog(
    context: context,
    builder: (con) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(
        description,
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onAccepted,
          child: const Text('Yes'),
        )
      ],
    ),
  );
}
