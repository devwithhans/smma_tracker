import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/widgets/custom_app_bar.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:agency_time/utils/widgets/filter_scroll.dart';
import 'package:agency_time/views/view_settings/web/edit_tags_view/edit_or_add_tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class EditTagsView extends StatefulWidget {
  const EditTagsView({Key? key}) : super(key: key);

  @override
  State<EditTagsView> createState() => _EditTagsViewState();
}

class _EditTagsViewState extends State<EditTagsView> {
  List<Tag> searchResult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResult = BlocProvider.of<AuthorizationCubit>(context)
        .state
        .company!
        .tags
        .where(((element) => element.active))
        .toList();
  }

  String searchParameter = '';

  @override
  Widget build(BuildContext context) {
    AppUser user = BlocProvider.of<AuthorizationCubit>(context).state.appUser!;
    Company company =
        BlocProvider.of<AuthorizationCubit>(context).state.company!;
    List<Tag> tags = company.tags.where(((element) => element.active)).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: 'Edit tags',
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomSearchField(
                    hintText: 'Search or create a new tag',
                    onSearch: (v) {
                      searchParameter = v;
                      searchResult = tags
                          .where((element) => element.tag
                              .toLowerCase()
                              .contains(v.toLowerCase()))
                          .toList();

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10),
                  SelectCard(
                    onTap: () {
                      pushEditTagScreen(
                          true,
                          Tag(
                              description: '',
                              tag: searchParameter,
                              id: Timestamp.now().microsecondsSinceEpoch));
                    },
                    text: 'Create tag ',
                    secondaryText: searchParameter,
                    preIcon: Icon(Icons.add_rounded),
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: searchResult
                        .map((e) => SelectCard(
                              onTap: () {
                                pushEditTagScreen(false, e);
                              },
                              text: e.tag,
                              height: 50,
                              margin: EdgeInsets.only(bottom: 10),
                            ))
                        .toList(),
                  ),
                ],
              ),
            )
            // Expanded(child: child)
          ],
        ),
      ),
    );
  }

  void pushEditTagScreen(bool newTag, Tag tag) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => editTag(isNewTag: newTag, tags: tag)),
      ),
    );
    searchResult = BlocProvider.of<AuthorizationCubit>(context)
        .state
        .company!
        .tags
        .where(((element) => element.active))
        .toList();
    setState(() {});
  }
}
