import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorizeRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<AppUser?> getAppUser(
    String uid,
  ) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot userDocument =
        await users.doc(uid).get().timeout(const Duration(seconds: 5));

    if (userDocument.data() == null) return null;

    return AppUser.convert(userDocument.data() as Map<String, dynamic>, uid);
  }

  Future<Company?> getCompany(
    String uid,
  ) async {
    QuerySnapshot<Map<String, dynamic>> companyRaw = await FirebaseFirestore
        .instance
        .collection('companies')
        .where('owner', isEqualTo: uid)
        .limit(1)
        .get()
        .timeout(Duration(seconds: 2))
        .catchError((e) {
      print(e);
    });
    if (companyRaw.docs.isEmpty) return null;
    print(companyRaw);
    // Company company =
    //     Company.convert(companyRaw.docs.first.data(), companyRaw.docs.first.id);

    // company = await _addMembersToCompanyDocument(company);

    // return company;
  }
}
