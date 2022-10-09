import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/logic/data_visualisation/models/month.dart';
import 'package:agency_time/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DataRepository {
  AuthorizationCubit authCubit;
  DataRepository(this.authCubit);

  Stream monthsStream() {
    return FirebaseFirestore.instance
        .collection('companies')
        .doc(authCubit.state.appUser!.companyId)
        .collection('months')
        .orderBy('updatedAt')
        .snapshots();
  }

  Future<List<Month>> getMonths(int lastX) async {
    String companyId = authCubit.state.appUser!.companyId!;

    QuerySnapshot<Map<String, dynamic>> months = await FirebaseFirestore
        .instance
        .collection('companies')
        .doc(companyId)
        .collection('months')
        .orderBy('updatedAt')
        .limitToLast(12)
        .get();
    List<Month> monthsList = [];

    for (var i in months.docs) {
      monthsList.add(Month.fromMap(i.data()));
    }
    return monthsList;
  }

  Future<void> createNewMonth() async {
    String companyId = authCubit.state.company!.id;
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    firebaseFunctions.useFunctionsEmulator('localhost', 5001);

    try {
      HttpsCallable callable = firebaseFunctions.httpsCallable('upToDateMonth',
          options: HttpsCallableOptions());
      final resp = await callable.call(<String, dynamic>{
        'companyId': companyId,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e);
    }
  }

  Future<void> checkIfMonthsUpToDate() async {
    AppUser user = authCubit.state.appUser!;
    DateTime month = DateTime.now();
    String monthId = '${month.year}-${month.month}';
    if (month.isAfter(DateTime.now())) {
      throw Exception('You cannot choose a future month');
    }

    DocumentSnapshot<Map<String, dynamic>> companyMonth;
    companyMonth = await FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('months')
        .doc(monthId)
        .get();
    if (!companyMonth.exists) {
      await createNewMonth();
    }
  }
}
