import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

Future<Duration?> editDuration(BuildContext context, Duration duration) {
  Duration _duration = duration;

  return showDialog<Duration>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            return Dialog(
                child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Edit duration',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Theme(
                          data: ThemeData(
                            primarySwatch: Colors.green,
                          ),
                          child: DurationPicker(
                            onChange: (v) {
                              setState(() => _duration = v);
                            },
                            duration: _duration,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Annuler',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                text: 'Gem',
                                onPressed: () {
                                  Navigator.pop(context, _duration);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    )));
          }));
}
