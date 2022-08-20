import 'package:agency_time/functions/authentication/web_view/web_no_company.dart';
import 'package:flutter/material.dart';

class AccountType extends StatefulWidget {
  const AccountType({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  bool forMySelfe = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Let\'s set up your company',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
          ),
          const Text(
            'It only takes a few seconds',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 40),
          BigBorderButton(
            selected: !forMySelfe,
            mainText: 'For my team',
            onPressed: () {
              forMySelfe = false;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          BigBorderButton(
            selected: forMySelfe,
            mainText: 'For my selfe',
            onPressed: () {
              forMySelfe = true;
              setState(() {});
            },
          ),
        ]);
  }
}
