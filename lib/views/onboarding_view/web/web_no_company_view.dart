import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/invite.dart';
import 'package:agency_time/functions/authentication/web_view/web_no_company.dart';
import 'package:agency_time/functions/payments/web_views/web_new_company/web_new_company.dart';
import 'package:agency_time/utils/constants/spacings.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebNoCompany extends StatelessWidget {
  const WebNoCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState authState = context.read<AuthCubit>().state;
    bool hasInvite = authState.invite != null;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 1000, maxWidth: 600),
            child: hasInvite
                ? HasInvite(invite: authState.invite!)
                : const NoInvite(),
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
          style: AppTextStyle.largeBold,
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
        )
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
          style: AppTextStyle.largeBold,
        ),
        Text(
          '${invite.inviterName} has invited you to join ${invite.companyName}!',
          textAlign: TextAlign.center,
          style: AppTextStyle.mediumBold,
        ),
        xtraLargeY,
        BigBorderButton(
          mainText: 'Join the ${invite.companyName} team',
          onPressed: () {
            context.read<AuthCubit>().acceptInvite(invite.id);
          },
        ),
        mediumY,
        CustomTextButton(
          text: 'I dont know the company',
          onPressed: () {
            Navigator.pushNamed(context, WebNewCompany.pageName);
          },
        )
      ],
    );
  }
}
