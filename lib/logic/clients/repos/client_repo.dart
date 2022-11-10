import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/models/tracking.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';

import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ClientsRepo {
  AuthorizeCubit authCubit;
  ClientsRepo(this.authCubit);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> pauseClient(
      {required String id, required bool paused, required double mrr}) async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    firebaseFunctions.useFunctionsEmulator('localhost', 5001);

    DocumentReference clientDocument = firestore
        .collection('companies')
        .doc(authCubit.state.company!.id)
        .collection('clients')
        .doc(id)
        .collection('months')
        .doc('${DateTime.now().year}-${DateTime.now().month}');

    await clientDocument.update({
      'paused': paused,
    });
  }

  Future<void> editClient({
    required double mrr,
    required double hourlyRateTarget,
    required String name,
    required String description,
    required String id,
  }) async {
    AppUser user = authCubit.state.appUser!;

    DocumentReference clientDocument = firestore
        .collection('companies')
        .doc(user.companyId)
        .collection('clients')
        .doc(id);

    try {
      await clientDocument.update({
        'name': name,
        'mrr': mrr,
        'description': mrr,
        'target_hourly_rate': hourlyRateTarget,
      });
      await clientDocument
          .collection('months')
          .doc('${DateTime.now().year}-${DateTime.now().month}')
          .set({
        'name': name,
        'mrr': mrr,
        'target_hourly_rate': hourlyRateTarget,
        'updatedAt': DateTime.now()
      }, SetOptions(merge: true));
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
        .where('paused', isEqualTo: false)
        .snapshots();
  }

  List<Tag> getTags() {
    return authCubit.state.company!.tags;
  }

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
