import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorizeRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<AppUser?> getAppUser(
    String uid,
  ) async {
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .timeout(const Duration(seconds: 5));

    if (userDocument.data() == null) return null;

    return AppUser.convert(userDocument.data() as Map<String, dynamic>, uid);
  }

  Future<Company?> getCompany(
    String uid,
  ) async {
    QuerySnapshot<Map<String, dynamic>> companyRaw = await FirebaseFirestore
        .instance
        .collection('companies')
        .where('roles.' + uid, isNull: false)
        .limit(1)
        .get()
        .timeout(Duration(seconds: 2))
        .catchError((e) {
      print(e);
    });
    if (companyRaw.docs.isEmpty) return null;

    Company company =
        Company.convert(companyRaw.docs.first.data(), companyRaw.docs.first.id);

    company = await _addMembersToCompanyDocument(company);

    return company;
  }

  Future<Company> _addMembersToCompanyDocument(Company company) async {
    List<UserData> members = [];
    List membersUIDs = company.roles.keys.toList();
    print(membersUIDs);
    for (var uid in membersUIDs) {
      DocumentSnapshot<Map<String, dynamic>> member =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      members.add(UserData.convert(member.data()!, uid));
    }

    company = company.copyWith(members: members);
    return company;
  }
}
