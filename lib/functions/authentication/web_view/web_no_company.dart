import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/invite.dart';
import 'package:agency_time/functions/payments/web_views/web_new_company/web_new_company.dart';
import 'package:agency_time/utils/constants/colors.dart';
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
          constraints: BoxConstraints(maxHeight: 1000, maxWidth: 600),
          child: hasInvite ? HasInvite(invite: authState.invite!) : NoInvite(),
        ),
      ),
    ));
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
        const Text(
          'Welcome to SMMA Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
        ),
        const Text(
          'You are not attached any company yet. Choose how you wanna continue',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 40),
        BigBorderButton(
          mainText: 'I wanna create a new company',
          subText: 'Create a new company to start tracking',
          onPressed: () {
            Navigator.pushNamed(context, WebNewCompany.pageName);
          },
        ),
        SizedBox(height: 20),
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
    AuthState authState = context.read<AuthCubit>().state;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'You have an invite 🥳',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
        ),
        Text(
          '${invite.inviterName} has invited you to join ${invite.companyName}!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 40),
        BigBorderButton(
          mainText: 'Join the ${invite.companyName} team',
          onPressed: () {
            context.read<AuthCubit>().acceptInvite(invite.id);
          },
        ),
        SizedBox(height: 10),
        CustomTextButton(text: 'I dont know the company', onPressed: () {})
      ],
    );
  }
}

class BigBorderButton extends StatelessWidget {
  const BigBorderButton({
    required this.mainText,
    required this.onPressed,
    this.selected = false,
    this.subText,
    Key? key,
  }) : super(key: key);

  final String mainText;
  final bool selected;
  final String? subText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: selected ? Colors.blue : Colors.white,
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(minHeight: 100),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: kColorGrey),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mainText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subText == null
              ? SizedBox()
              : Text(
                  subText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }
}
