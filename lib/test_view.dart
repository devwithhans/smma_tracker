import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestingWidget extends StatelessWidget {
  const TestingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState auth = BlocProvider.of<AuthCubit>(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('TESTING'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomElevatedButton(
                text: 'Test button 1',
                onPressed: () async {
                  await testFunction();
                })
          ],
        ),
      ),
    );
  }
}

Future<void> testFunction() async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('stopTracker');

  try {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('attachCreditCard', options: HttpsCallableOptions());
    final resp = await callable.call();
    print(resp);
  } on FirebaseFunctionsException catch (e) {
    print(e);
  }
}
