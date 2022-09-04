import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/views/view_enter_app/web/web_login_user_view.dart';
import 'package:agency_time/views/view_enter_app/web/web_register_user_view.dart';
import 'package:flutter/material.dart';

enum EnterAppPushScreen { login, register }

class EnterAppHeadline extends StatelessWidget {
  const EnterAppHeadline({
    required this.subTitle,
    required this.title,
    required this.pushScreen,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final EnterAppPushScreen pushScreen;

  @override
  Widget build(BuildContext context) {
    Widget _pushScreen() {
      if (pushScreen == EnterAppPushScreen.register) {
        return TextButton(
          onPressed: () {
            Navigator.pushNamed(context, WebRegisterView.pageName);
          },
          child: const Text('create a new account'),
        );
      } else {
        return TextButton(
          onPressed: () {
            Navigator.pushNamed(context, WebLoginView.pageName);
          },
          child: const Text('Login to an existing account'),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.boldLarge,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              subTitle,
              style: AppTextStyle.medium,
            ),
            _pushScreen(),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
