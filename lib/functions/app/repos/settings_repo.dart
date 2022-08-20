import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SettingsRepo {
  AuthCubit authCubit;
  SettingsRepo(this.authCubit);
  String? getCountryCodeFromCompanyDoc() {
    Company company = authCubit.state.company!;
    return company.countryCode;
  }

  Future<void> deleteTag(Tag tag) async {
    AppUser user = authCubit.state.appUser!;
    try {
      // FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

      FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .update({
        'tags.${tag.id}': {
          'tag': tag.tag,
          'description': tag.description,
          'active': false,
        }
      });
    } on FirebaseFunctionsException catch (error) {
      rethrow;
    }
  }

  Future<void> addTag(Tag tag) async {
    AppUser user = authCubit.state.appUser!;

    try {
      // FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

      FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .update({
        'tags.${tag.id}': {
          'tag': tag.tag,
          'description': tag.description,
        }
      });
    } on FirebaseFunctionsException catch (error) {
      rethrow;
    }
  }

  Future<void> setCountryCodeInCompanyDoc(String countryCode) async {
    AppUser user = authCubit.state.appUser!;

    try {
      // FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

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
    FirebaseFunctions firebaseFunctions =
        FirebaseFunctions.instanceFor(region: 'europe-west1');

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

  Future<void> checkIfMonthsUpToDate() async {
    AppUser user = authCubit.state.appUser!;
    DateTime month = DateTime.now();
    String monthId = '${month.year}-${month.month}';
    print('here');
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
