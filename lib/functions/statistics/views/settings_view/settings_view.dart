import 'package:agency_time/functions/statistics/views/settings_view/settings_sub_views/edit_tags_view/edit_tags_view.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/user.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser user = BlocProvider.of<AuthorizationCubit>(context).state.appUser!;
    Company company =
        BlocProvider.of<AuthorizationCubit>(context).state.company!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.firstName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    company.companyName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 0,
            ),

            Expanded(
              child: ListView(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTagsView(),
                          ));
                    },
                    text: 'Edit Tags',
                    icon: Icons.tag_rounded,
                  ),
                  CustomIconButton(
                      onPressed: () {},
                      text: 'Change currency',
                      icon: Icons.euro),
                  CustomIconButton(
                    onPressed: () {},
                    text: 'Manage employees',
                    icon: Icons.account_circle_sharp,
                  ),
                  CustomIconButton(
                    onPressed: () {},
                    text: 'Data settings',
                    icon: Icons.data_usage_rounded,
                  ),
                  Divider(
                    height: 5,
                  ),
                  CustomIconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    text: 'Logout',
                    icon: Icons.logout,
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
}
