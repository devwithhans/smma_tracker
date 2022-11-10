import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createCompany({
    required String name,
    required String countryCode,
    required String userId,
    required String? vatNumber,
  }) async {
    DocumentReference<Map<String, dynamic>> result =
        await firestore.collection('companies').add({
      'companyName': name,
      'countryCode': countryCode,
      'vatNumber': vatNumber,
      'owner': userId
    });
    await firestore.collection('users').doc(userId).update({
      'companyId': result.id,
    });
  }
}
