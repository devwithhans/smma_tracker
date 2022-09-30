import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/new_data_handling/models/month.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataReposity {
  AuthorizationCubit authCubit;
  DataReposity(this.authCubit);

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
        .doc('QyuKKbXD4fX3ipFca2se')
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
}
