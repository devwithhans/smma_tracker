import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/logic/settings/repos/settings_repo.dart';
import 'package:agency_time/utils/widgets/custom_app_bar.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/widgets/buttons/main_button.dart';
import '../../../../utils/widgets/buttons/text_button.dart';

class editTag extends StatelessWidget {
  const editTag({required this.isNewTag, required this.tags, Key? key})
      : super(key: key);
  final Tag tags;
  final bool isNewTag;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final List oldTags = context.read<AuthorizeCubit>().state.company!.tags;
    String tag = tags.tag;
    String description = tags.description;
    int id = tags.id;
    void onSave() async {
      if (_formKey.currentState!.validate()) {
        try {
          Tag newTag = Tag(
            description: description,
            id: id,
            tag: tag,
          );
          await RepositoryProvider.of<SettingsRepo>(context).addTag(newTag);

          if (isNewTag) {
            context.read<AuthorizeCubit>().state.company!.tags.add(newTag);
          } else {
            context.read<AuthorizeCubit>().state.company!.tags[newTag.id] =
                newTag;
          }

          Navigator.pop(context);
        } catch (e) {
          print(e);
        }
      }
    }

    void onDelete() async {
      try {
        Tag newTag = Tag(
          description: description,
          id: id,
          tag: tag,
          active: false,
        );
        await RepositoryProvider.of<SettingsRepo>(context).deleteTag(newTag);

        int index = oldTags.indexWhere((element) => element.id == newTag.id);

        context.read<AuthorizeCubit>().state.company!.tags[index] = newTag;

        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: '',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Form(
                      key: _formKey,
                      child: ListView(children: [
                        Column(
                          children: [
                            CustomInputForm(
                              onChanged: (v) {
                                tag = v;
                              },
                              initialValue: tag,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter a tag name';
                                }
                              },
                              title: 'Tag name',
                              hintText: 'Eg. phone calls',
                            ),
                            SizedBox(height: 30),
                            CustomInputForm(
                              maxLines: 4,
                              onChanged: (v) {
                                description = v;
                              },
                              title: 'Description (optional)',
                              hintText: 'Add a description',
                            ),
                          ],
                        )
                      ]),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomElevatedButton(
                              backgroundColor: kColorGreen,
                              text: 'Save',
                              onPressed: onSave,
                            ),
                            isNewTag
                                ? SizedBox()
                                : CustomTextButton(
                                    text: 'Move to bin',
                                    onPressed: onDelete,
                                  ),
                            // SizedBox(height: 15),
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
