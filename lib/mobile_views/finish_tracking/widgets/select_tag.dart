import 'package:agency_time/mobile_views/bottom_navigation.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTag extends StatefulWidget {
  const SelectTag({
    this.error,
    required this.onSelected,
    this.initialTag,
    Key? key,
  }) : super(key: key);

  final String? error;
  final void Function(Tag tag) onSelected;
  final Tag? initialTag;

  @override
  State<SelectTag> createState() => _SelectTagState();
}

bool _newTag = false;
String? typedTag;
int? selected;
final _formKey = GlobalKey<FormState>();

class _SelectTagState extends State<SelectTag> {
  @override
  void initState() {
    super.initState();
    selected = widget.initialTag != null ? widget.initialTag!.id : null;
  }

  @override
  Widget build(BuildContext context) {
    List<Tag> tags =
        RepositoryProvider.of<TrackerRepository>(context).getTags();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.error ?? '',
          style: TextStyle(color: Colors.red),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  const Text(
                    'Select tag',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {
                      _newTag = true;
                      setState(() {});
                    },
                    icon: Icon(Icons.add_circle),
                    splashRadius: 20,
                  )
                ],
              ),
              Visibility(
                visible: _newTag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomInputForm(
                        validator: (v) {
                          if (v == null) {
                            return 'Please name the new tag';
                          }
                        },
                        onChanged: (v) {
                          typedTag = v;
                        },
                        autofocus: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonStyle: CustomButtonStyle.blackborder,
                              text: 'Cancel',
                              onPressed: () {
                                _newTag = false;
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              text: 'Save',
                              onPressed: () {
                                if (_newTag &&
                                    _formKey.currentState!.validate()) {
                                  addNewTag(tags);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: !_newTag,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: tagsWidgets(tags)),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  addNewTag(List<Tag> tags) {
    // Setting a unique id with a timestamp
    int newTagId = DateTime.now().millisecondsSinceEpoch;
    // Creating the object to push to the
    Tag newTagMap = Tag(description: '', id: newTagId, tag: typedTag!);
    tags.insert(0, newTagMap);
    _newTag = false;
    selectTag(newTagMap);
    RepositoryProvider.of<TrackerRepository>(context).addTag(
      tag: typedTag!,
      description: '',
      id: newTagId,
    );
    setState(() {});
  }

  tagsWidgets(List<Tag> tags) {
    List<Widget> result = [];
    tags.forEach((value) {
      result.add(SelectCard(
        text: value.tag,
        margin: EdgeInsets.only(bottom: 10),
        height: 50,
        selected: selected == value.id,
        onTap: () {
          selectTag(value);
        },
      ));
    });
    return result;
  }

  selectTag(Tag tag) {
    selected = tag.id;
    widget.onSelected(tag);
    setState(() {});
  }
}
