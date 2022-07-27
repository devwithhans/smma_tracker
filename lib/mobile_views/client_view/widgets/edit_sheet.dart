import 'package:agency_time/blocs/update_trackig_cubit/update_tracking_cubit.dart';
import 'package:agency_time/mobile_views/finish_tracking/widgets/edit_duration.dart';
import 'package:agency_time/mobile_views/finish_tracking/widgets/select_tag.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/models/tracking.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
  DateTime? _newDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateTrackingCubit(context.read<TrackerRepository>()),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Edit duration',
          style: TextStyle(color: Colors.black),
        )),
        body: BlocBuilder<UpdateTrackingCubit, UpdateTrackingState>(
          builder: (context, state) {
            if (state is UpdateTrackingLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 50),
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonStyle: CustomButtonStyle.blackborder,
                      )),
                      SizedBox(width: 15),
                      Expanded(
                        child: CustomButton(
                          text: 'Save',
                          onPressed: () {
                            context.read<UpdateTrackingCubit>().updateTracking(
                                widget.tracking,
                                _newDuration ?? widget.tracking.duration,
                                _newTag ?? widget.tracking.tag);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

class SelectTagView extends StatelessWidget {
  const SelectTagView({
    required this.initialTag,
    Key? key,
  }) : super(key: key);

  final Tag initialTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select tag',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SelectTag(
        initialTag: initialTag,
        onSelected: (tag) {
          Navigator.pop(context, tag);
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
              fontWeight: FontWeight.w600,
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
