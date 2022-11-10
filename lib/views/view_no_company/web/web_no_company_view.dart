import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/models/invite.dart';
import 'package:agency_time/utils/constants/spacings.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/buttons/xl_border_button.dart';
import 'package:agency_time/views/view_register_company/web/web_register_company_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/widgets/buttons/text_button.dart';

class WebNoCompany extends StatelessWidget {
  const WebNoCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthorizeState authState = context.read<AuthorizeCubit>().state;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 1000, maxWidth: 600),
            child: NoInvite(),
          ),
        ),
      ),
    );
  }
}

class NoInvite extends StatelessWidget {
  const NoInvite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome to SMMA Tracker',
          textAlign: TextAlign.center,
          style: AppTextStyle.boldLarge,
        ),
        Text(
          'You are not attached any company yet. Choose how you wanna continue',
          textAlign: TextAlign.center,
          style: AppTextStyle.medium,
        ),
        xtraLargeY,
        BigBorderButton(
          mainText: 'I wanna create a new company',
          subText: 'Create a new company to start tracking',
          onPressed: () {
            Navigator.pushNamed(context, WebNewCompany.pageName);
          },
        ),
        largeY,
        BigBorderButton(
          mainText: 'I am part of a team',
          subText: 'Join an existing company',
          onPressed: () {},
        ),
        mediumY,
        CustomTextButton(
          text: 'Sign out',
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}

class HasInvite extends StatelessWidget {
  const HasInvite({
    Key? key,
    required this.invite,
  }) : super(key: key);

  final Invite invite;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'You have an invite 🥳',
          textAlign: TextAlign.center,
          style: AppTextStyle.boldLarge,
        ),
        Text(
          '${invite.inviterName} has invited you to join ${invite.companyName}!',
          textAlign: TextAlign.center,
          style: AppTextStyle.boldSmall,
        ),
        xtraLargeY,
        BigBorderButton(
          mainText: 'Join the ${invite.companyName} team',
          onPressed: () {
            // context.read<AuthCubit>().acceptInvite(invite.id);
          },
        ),
        mediumY,
        CustomTextButton(
          text: 'I dont know the company',
          onPressed: () {
            Navigator.pushNamed(context, WebNewCompany.pageName);
          },
        ),
        mediumY,
        CustomTextButton(
          text: 'Sign out',
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}
