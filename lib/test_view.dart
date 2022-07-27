import 'package:agency_time/blocs/auth_cubit/auth_cubit.dart';
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
            // CustomButton(
            //     text: 'Test button 1',
            //     onPressed: () {
            //       startTracker(
            //         userId: auth.appUser!.id,
            //         userName: auth.appUser!.firstName,
            //         companyId: auth.appUser!.companyId,
            //         start: DateTime.now().toString(),
            //         clientId: 'SHIIII',
            //         clientName: 'userName',
            //       );
            //     })
          ],
        ),
      ),
    );
  }
}

Future<void> stopTracker({
  required String clientId,
  required String clientName,
  required String companyId,
  required DateTime start,
  required String userId,
  required String userName,
}) async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('stopTracker');

  try {
    final resp = await callable.call({
      'clientId': clientId,
      'clientName': clientName,
      'companyId': companyId,
      'start': start,
      'userId': userId,
      'userName': userName,
    });
    print(resp);
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.message);
  }
}
