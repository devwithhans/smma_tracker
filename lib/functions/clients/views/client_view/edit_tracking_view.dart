import 'package:agency_time/functions/clients/views/client_view/select_tag_view.dart';
import 'package:agency_time/functions/clients/views/client_view/widgets/custom_app_bar.dart';
import 'package:agency_time/functions/tracking/blocs/update_trackig_cubit/update_tracking_cubit.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/models/tracking.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/widgets/edit_duration.dart';

import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_alert_dialog.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/edit_value_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTracking extends StatefulWidget {
  const EditTracking({
    required this.tracking,
    Key? key,
  }) : super(key: key);
  final Tracking tracking;

  @override
  State<EditTracking> createState() => _EditTrackingState();
}

class _EditTrackingState extends State<EditTracking> {
  Duration? _newDuration;
  Tag? _newTag;
  DateTime? newStart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateTrackingCubit(context.read<TrackerRepo>()),
      child: Scaffold(
        body: BlocBuilder<UpdateTrackingCubit, UpdateTrackingState>(
          builder: (context, state) {
            if (state is UpdateTrackingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(title: 'Edit Tracking'),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          editTrackedDuration(context),
                          SizedBox(height: 20),
                          editTag(context),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomElevatedButton(
                          text: 'Save',
                          backgroundColor: kColorGreen,
                          onPressed: () {
                            context.read<UpdateTrackingCubit>().updateTracking(
                                  widget.tracking,
                                  _newDuration ?? widget.tracking.duration,
                                  _newTag != null
                                      ? _newTag!.id
                                      : widget.tracking.tag.id,
                                );
                          },
                        ),
                        CustomTextButton(
                          onPressed: () {
                            customAlertDialog(
                                context: context,
                                title: 'Confirm deletion',
                                description:
                                    'Are you sure you wanna delete this tracking',
                                onAccepted: () {
                                  context
                                      .read<UpdateTrackingCubit>()
                                      .deleteTracking(widget.tracking.id);
                                });
                          },
                          textColor: kColorRed,
                          text: 'Delete',
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  EditValueField editTrackedDuration(BuildContext context) {
    return EditValueField(
      title: 'Duration:',
      value: printDuration(
        _newDuration ?? widget.tracking.duration,
      ),
      onPressed: () async {
        _newDuration = await editDuration(
            context, _newDuration ?? widget.tracking.duration);
        setState(() {});
      },
    );
  }

  EditValueField editTag(BuildContext context) {
    return EditValueField(
      title: 'Tag:',
      value: _newTag != null ? _newTag!.tag : widget.tracking.tag.tag,
      onPressed: () async {
        _newTag = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectTagView(
              initialTag: _newTag != null ? _newTag! : widget.tracking.tag,
            ),
          ),
        );

        setState(() {});
      },
    );
  }
}
