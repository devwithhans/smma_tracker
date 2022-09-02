import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/models/tracking.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientsRepo {
  AuthorizationCubit authCubit;
  ClientsRepo(this.authCubit);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getClientMonth(
      String monthId, String clientId) async {
    AppUser user = authCubit.state.appUser!;

    DocumentSnapshot result = await firestore
        .collection('companies')
        .doc(user.companyId)
        .collection('clients')
        .doc(clientId)
        .collection('months')
        .doc(monthId)
        .get();

    if (result.exists) {
      return result.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<Client> editClient(Client newValues) async {
    AppUser user = authCubit.state.appUser!;

    DocumentReference clientDocument = firestore
        .collection('companies')
        .doc(user.companyId)
        .collection('clients')
        .doc(newValues.id);

    try {
      await clientDocument.update({
        'name': newValues.name,
        'mrr': newValues.selectedMonth!.mrr,
        'target_hourly_rate': newValues.selectedMonth!.hourlyRateTarget
      });
      await clientDocument
          .collection('months')
          .doc('${DateTime.now().year}-${DateTime.now().month}')
          .set({
        'name': newValues.name,
        'mrr': newValues.selectedMonth!.mrr,
        'target_hourly_rate': newValues.selectedMonth!.hourlyRateTarget,
        'updatedAt': DateTime.now()
      }, SetOptions(merge: true));
      return newValues;
    } on FirebaseException catch (e) {
      print(e.message);
      print(e.code);
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> clientsSubscription() {
    AppUser user = authCubit.state.appUser!;
    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('clients')
        .snapshots();
  }

  List<Tag> getTags() {
    return authCubit.state.company!.tags;
  }

  // Future<void> setClientMonth(Month lastMonth, String clientId) async {
  //   // AppUser user = authCubit.state.appUser!;
  //   // String monthId = '${DateTime.now().year}-${DateTime.now().month}';
  //   // FirebaseFirestore.instance
  //   //     .collection('companies')
  //   //     .doc(user.companyId)
  //   //     .collection('clients')
  //   //     .doc(clientId)
  //   //     .collection('months')
  //   //     .doc(monthId)
  //   //     .set(
  //   //   {
  //   //     'mrr': lastMonth.mrr,
  //   //     'updatedAt': DateTime.now(),
  //   //   },
  //   //   SetOptions(merge: true),
  //   // );
  // }

  Future<List<Tracking>> getTrackings(
      int skip, String clientId, int limit) async {
    AppUser user = authCubit.state.appUser!;
    List<Tracking> resultArray = [];
    try {
      QuerySnapshot<Map<String, dynamic>> result = await firestore
          .collection('companies')
          .doc(user.companyId)
          .collection('trackings')
          .where('clientId', isEqualTo: clientId)
          .where('finished', isEqualTo: true)
          .orderBy('start', descending: true)
          .limit(limit)
          .get();

      if (result.docs.isEmpty) return [];

      for (var e in result.docs) {
        Map trackDoc = e.data();
        Timestamp start = trackDoc['start'];
        Timestamp stop = trackDoc['stop'] ?? Timestamp.now();
        Tag tag = authCubit.state.company!.tags
            .firstWhere((element) => element.id == trackDoc['tag']);

        resultArray.add(
          Tracking(
            id: e.id,
            tag: tag,
            clientId: trackDoc['clientId'],
            clientName: trackDoc['clientName'],
            duration: Duration(seconds: trackDoc['duration']),
            start: DateTime.fromMicrosecondsSinceEpoch(
                start.microsecondsSinceEpoch),
            stop: DateTime.fromMicrosecondsSinceEpoch(
                stop.microsecondsSinceEpoch),
            userId: trackDoc['userId'],
            userName: trackDoc['userName'],
          ),
        );
      }
      return resultArray;
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    }
  }
}
