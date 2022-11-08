import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/models/company_month.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SettingsRepo {
  AuthorizeCubit authCubit;
  SettingsRepo(this.authCubit);
  String? getCountryCodeFromCompanyDoc() {
    Company company = authCubit.state.company!;
    return company.countryCode;
  }

  Future<void> deleteTag(Tag tag) async {
    AppUser user = authCubit.state.appUser!;
    try {
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

  // Future getCurrentMonth() async {
  //   AppUser user = authCubit.state.appUser!;
  //   DocumentSnapshot<Map<String, dynamic>> currentMonth =
  //       await FirebaseFirestore.instance
  //           .collection('companies')
  //           .doc(user.companyId)
  //           .collection('month')
  //           .doc()
  //           .get();

  //   return CompanyMonth.convertMonth(
  //       currentMonth.data(), currentMonth.id, authCubit.state.company!);
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> companyCurrentDayStream() {
    AppUser user = authCubit.state.appUser!;

    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('days')
        .orderBy('day')
        .limitToLast(2)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> companyCurrentMonthStream() {
    AppUser user = authCubit.state.appUser!;

    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('months')
        .orderBy('updatedAt')
        .limitToLast(2)
        .snapshots(includeMetadataChanges: true);
  }
}
