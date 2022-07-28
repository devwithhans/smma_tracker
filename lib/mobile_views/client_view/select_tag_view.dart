import 'package:agency_time/mobile_views/finish_tracking/widgets/select_tag.dart';
import 'package:agency_time/models/tag.dart';
import 'package:flutter/material.dart';

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
