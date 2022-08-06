import 'package:agency_time/functions/app/models/stats.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SettingsRepo {
  AuthCubit authCubit;
  SettingsRepo(this.authCubit);
  String? getCountryCodeFromCompanyDoc() {
    Company company = authCubit.state.company!;
    return company.countryCode;
  }

  Future<void> setCountryCodeInCompanyDoc(String countryCode) async {
    AppUser user = authCubit.state.appUser!;

    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

      FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .update({'countyCode': countryCode});
    } on FirebaseFunctionsException catch (error) {
      rethrow;
    }
  }

  Future<void> createNewMonth() async {
    String companyId = authCubit.state.company!.id;
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;

    firebaseFunctions.useFunctionsEmulator('localhost', 5001);
    try {
      HttpsCallable callable = firebaseFunctions.httpsCallable('startNewMonth',
          options: HttpsCallableOptions());
      final resp = await callable.call(<String, dynamic>{
        'companyId': companyId,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> companyMonths() {
    AppUser user = authCubit.state.appUser!;

    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('months')
        .limit(12)
        .snapshots(includeMetadataChanges: true);
  }
}
