import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/widgets/duration_formfield.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/widgets/search_tags.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_alert_dialog.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishTrackingDialog extends StatefulWidget {
  const FinishTrackingDialog({
    Key? key,
    required this.tags,
    this.tag,
    required this.client,
    required this.onDelete,
    required this.onSave,
    required this.duration,
  }) : super(key: key);

  final Duration duration;
  final List<Tag> tags;
  final Tag? tag;
  final ClientLite client;
  final void Function(Tag? selected, Duration duration) onSave;
  final void Function() onDelete;

  @override
  State<FinishTrackingDialog> createState() => _FinishTrackingDialogState();
}

class _FinishTrackingDialogState extends State<FinishTrackingDialog> {
  Duration _duration = const Duration();
  Duration? _newDuration;

  Tag? selectedTag;
  List<Tag> tags = [];
  bool newTag = false;
  String typedTag = '';

  @override
  void initState() {
    super.initState();
    selectedTag = widget.tag;
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.close),
                    padding: EdgeInsets.zero,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Finish ${widget.client.name} tracking',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                const v = 'v';
              },
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Original: ${printDuration(_duration)}',
                      ),
                      DurationFormField(
                        initialDuration: _newDuration ?? _duration,
                        onChanged: (v) {
                          _newDuration = v;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  widget.client.internal
                      ? SizedBox()
                      : SearchTags(
                          selectedTag: selectedTag,
                          onChange: (v) {
                            selectedTag = v;
                          },
                          tags: tags,
                        )
                ],
              ),
            )),
            Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormField(validator: (v) {
                    if (selectedTag == null) {
                      if (widget.client.internal) return null;

                      return 'You need to select or create a tag';
                    }
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        formState.hasError
                            ? Text(
                                formState.errorText ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              )
                            : SizedBox(),
                        CustomElevatedButton(
                          text: 'SAVE',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (selectedTag != null) {
                                if (tags
                                    .where((element) =>
                                        element.id == selectedTag!.id)
                                    .isEmpty) {
                                  RepositoryProvider.of<TrackerRepo>(context)
                                      .addTag(selectedTag!);
                                  context
                                      .read<AuthCubit>()
                                      .state
                                      .company!
                                      .tags
                                      .add(selectedTag!);
                                }
                              }
                              widget.onSave(
                                  selectedTag, _newDuration ?? _duration);
                            }
                          },
                          backgroundColor: kColorGreen,
                        ),
                      ],
                    );
                  }),
                  CustomTextButton(
                    text: 'Delete',
                    onPressed: () {
                      customAlertDialog(
                        context: context,
                        title: 'Are you sure you wanna delete this tracking?',
                        description: 'You cannot restore this tracking',
                        onAccepted: () {
                          widget.onDelete();
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      );
                    },
                    backgroundColor: kColorRed,
                    textColor: kColorRed,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
