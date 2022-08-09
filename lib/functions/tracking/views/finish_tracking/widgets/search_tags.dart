import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:flutter/material.dart';

class SearchTags extends StatefulWidget {
  const SearchTags({
    required this.tags,
    required this.onChange,
    Key? key,
  }) : super(key: key);
  final List<Tag> tags;
  final void Function(Tag?) onChange;
  @override
  State<SearchTags> createState() => _SearchTagsState();
}

class _SearchTagsState extends State<SearchTags> {
  List<Tag> searchResult = [];
  Tag? selectedTag;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResult = widget.tags.where((element) => element.active).toList();
  }

  String searchParameter = '';

  @override
  Widget build(BuildContext context) {
    widget.onChange(selectedTag);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSearchField(
          hintText: 'Add a tag',
          onSearch: (v) {
            searchParameter = v;
            searchResult = widget.tags
                .where((element) =>
                    element.tag.toLowerCase().contains(v.toLowerCase()) &&
                    element.active)
                .toList();

            setState(() {});
          },
        ),
        SizedBox(height: 10),
        Visibility(
          visible: selectedTag == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: searchResult
                .map((e) => SelectCard(
                      onTap: () {
                        selectedTag = e;
                        setState(() {});
                      },
                      selected: selectedTag == e,
                      text: e.tag,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 10),
                    ))
                .toList(),
          ),
        ),
        selectedTag != null
            ? SelectCard(
                onTap: () {
                  selectedTag = null;
                  searchParameter = '';
                  searchResult =
                      widget.tags.where((element) => element.active).toList();
                  setState(() {});
                },
                text: selectedTag!.tag,
                selected: true,
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
              )
            : SizedBox(),
        Visibility(
          visible: searchParameter.isNotEmpty &&
              searchResult.isEmpty &&
              selectedTag == null,
          child: SelectCard(
            onTap: () {
              selectedTag = Tag(
                description: '',
                id: DateTime.now().millisecondsSinceEpoch,
                tag: searchParameter,
              );
              setState(() {});
            },
            text: 'Create tag ',
            secondaryText: searchParameter,
            preIcon: Icon(Icons.add_rounded),
            height: 50,
            margin: EdgeInsets.only(bottom: 10),
          ),
        ),
      ],
    );
  }
}
