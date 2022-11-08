import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/models/company.dart';
import 'package:agency_time/models/invite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AuthRepo {
  AuthRepo();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<AppUser?> getUserDocument(
    String uid,
  ) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDocument;
    userDocument =
        await users.doc(uid).get().timeout(const Duration(seconds: 5));
    if (userDocument.data() == null) return null;
    return AppUser.convert(userDocument.data() as Map<String, dynamic>, uid);
  }

  Future<Company?> getCompany(
    String uid,
  ) async {
    print('hertil');

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

    Company company =
        Company.convert(companyRaw.docs.first.data(), companyRaw.docs.first.id);

    company = await _addMembersToCompanyDocument(company);

    return company;
  }

  Future<Company> _addMembersToCompanyDocument(Company company) async {
    List<UserData> members = [];
    List membersUIDs = company.roles.keys.toList();
    for (var uid in membersUIDs) {
      DocumentSnapshot<Map<String, dynamic>> member =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      members.add(UserData.convert(member.data()!, uid));
    }

    company = company.copyWith(members: members);
    return company;
  }

  Future<Invite?> checkForInvites(String email) async {
    DocumentSnapshot<Map<String, dynamic>> inviteRaw =
        await FirebaseFirestore.instance.collection('invites').doc(email).get();
    Invite? invite;
    if (inviteRaw.data() != null) {
      invite = Invite.convert(inviteRaw.data()!, inviteRaw.id);
    }

    return invite;
  }

  Future<void> acceptInvite(String email) async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    firebaseFunctions.useFunctionsEmulator('localhost', 5001);

    HttpsCallable callable = firebaseFunctions.httpsCallable('acceptInvite');
    final resp = await callable.call({
      'email': email,
    });
  }
}
