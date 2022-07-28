import 'package:agency_time/mobile_views/finish_tracking/finish_tracking_view.dart';
import 'package:agency_time/mobile_views/finish_tracking/widgets/edit_duration.dart';
import 'package:agency_time/mobile_views/finish_tracking/widgets/select_tag.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishTrackingDialog extends StatefulWidget {
  const FinishTrackingDialog({
    Key? key,
    required this.tags,
    required this.onDelete,
    required this.onSave,
    required this.duration,
  }) : super(key: key);

  final Duration duration;
  final List<Tag> tags;
  final void Function(int selected, Duration duration) onSave;
  final void Function() onDelete;

  @override
  State<FinishTrackingDialog> createState() => _FinishTrackingDialogState();
}

class _FinishTrackingDialogState extends State<FinishTrackingDialog> {
  Duration _duration = const Duration();
  int? selectedTagId;
  List<Tag> tags = [];
  bool newTag = false;
  String typedTag = '';

  @override
  void initState() {
    super.initState();
    tags = widget.tags;
    _duration = widget.duration;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Finish tracking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(
                      printDuration(Duration(seconds: _duration.inSeconds)),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: () async {
                        Duration? editedDuration =
                            await editDuration(context, _duration);
                        if (editedDuration != null) {
                          _duration = editedDuration;
                        }
                        setState(() {});
                      },
                      icon: Icon(Icons.edit),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Form(
            key: _formKey,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormField(
                      validator: (v) {
                        print(selected == null);
                        if (selected == null) {
                          return 'Please choose a category';
                        }
                      },
                      builder: (state) {
                        return SelectTag(
                          onSelected: ((tag) => selected = tag.id),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            text: 'Slet arbejde',
                            onPressed: () {
                              widget.onDelete();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomElevatedButton(
                            text: 'Gem arbejde',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                widget.onSave(selected!, _duration);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
