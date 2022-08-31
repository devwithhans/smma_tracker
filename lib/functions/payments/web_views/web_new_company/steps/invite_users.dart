import 'package:agency_time/functions/payments/models/new_company_cubit/new_company_cubit.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class InviteUsers extends StatefulWidget {
  const InviteUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<InviteUsers> createState() => _InviteUsersState();
}

class _InviteUsersState extends State<InviteUsers> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  bool forMySelfe = false;
  List<String> emails = [];
  TextEditingController _emailController = TextEditingController();
  List<String> teammates = [];
  String typingEmail = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Invite your teamates to track',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
          ),
          const Text(
            'Get complete overview, and invite all your teammates',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 40),
          CustomInputForm(
            controller: _controller,
            maxLines: 1,
            title: 'Invite with email',
            hintText: 'Type teamates email',
            onChanged: (c) {
              typingEmail = c;
            },
            validator: (value) {
              // if (teammates.contains(value)) {
              //   return 'Email has already been added';
              // }
              if (value == null || value.isEmpty) {
                return 'Field cannot be empty';
              }
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (!emailValid) {
                return 'Indtast venligst en gyldig mail';
              }
              return null;
            },
            onEditingComplete: () {
              if (_formKey.currentState!.validate()) {
                teammates.insert(0, typingEmail);
                _controller.clear();
                setState(() {});
              } else {}
            },
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 299),
            child: ListView(
              children: teammates
                  .map((e) => Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e),
                            IconButton(
                                onPressed: () {
                                  teammates
                                      .removeWhere((element) => element == e);
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          CustomElevatedButton(
              text: 'Next',
              onPressed: () {
                context
                    .read<ManageCompanyCubit>()
                    .updateValues(invites: teammates);
              })
        ],
      ),
    );
  }
}
