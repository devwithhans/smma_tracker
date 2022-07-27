import 'package:agency_time/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/models/tracking.dart';

import 'package:agency_time/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TrackerRepository {
  AuthCubit authCubit;
  TrackerRepository(this.authCubit);

  Future<String?> beginTracking(
      {required Client client, required DateTime start}) async {
    print('Start was called');
    AppUser user = authCubit.state.appUser!;

    try {
      final result = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .collection('trackings')
          .add({
        'start': start,
        'clientId': client.id,
        'userId': user.id,
        'userName': user.firstName,
        'clientName': client.name,
        'finished': false,
      });
      return result.id;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> stopTracker({
    required Duration duration,
    required String trackingDocId,
    required String clientId,
    required int tag,
    required DateTime stop,
  }) async {
    AppUser user = authCubit.state.appUser!;
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('stopTracker');

    try {
      final resp = await callable.call({
        'clientId': clientId,
        'duration': duration.inSeconds,
        'trackingDocId': trackingDocId,
        'tag': tag,
        'stop': stop.toString(),
        'companyId': user.companyId,
      });
      return resp.data;
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.message);
    }
  }

  Future<String?> updateTracking({
    required Duration duration,
    required Duration originalDuration,
    required String trackingDocId,
    required String clientId,
    required DateTime start,
    required int? tag,
  }) async {
    AppUser user = authCubit.state.appUser!;

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('updateTracking');

    print('jertto');
    try {
      final resp = await callable.call({
        'clientId': clientId,
        'durationChange': (duration - originalDuration).inSeconds,
        'duration': duration.inSeconds,
        'trackingDocId': trackingDocId,
        'tag': tag,
        'start': start.toString(),
        'companyId': user.companyId,
      });
      print(resp);
      return resp.data;
    } on FirebaseFunctionsException catch (error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }

  Future<TimerEvent?> checkForRunningTimer() async {
    AppUser user = authCubit.state.appUser!;

    CollectionReference trackings = FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('trackings');

    QuerySnapshot result = await trackings
        .where('userId', isEqualTo: user.id)
        .where('finished', isEqualTo: false)
        .get();

    print(result.docs.first.id);
    if (result.docs.isNotEmpty) {
      QueryDocumentSnapshot<Object?> singleResult = result.docs.first;
      DateTime startTime = singleResult['start'].toDate();
      int seconds = DateTime.now().difference(startTime).inSeconds;
      return TimerStarted(
        duration: Duration(seconds: seconds),
        documentId: singleResult.id,
        start: startTime,
        client: Client(
          hourlyRateTarget: 0,
          id: singleResult['clientId'],
          name: singleResult['clientName'],
          mrr: 0,
        ),
      );
    }
    return null;
  }

  Future<void> addTag(
      {required String tag,
      required String description,
      required int id}) async {
    AppUser user = authCubit.state.appUser!;

    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

      FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .update({
        'tags.$id': {
          'tag': tag,
          'description': description,
        }
      });
    } on FirebaseFunctionsException catch (error) {
      rethrow;
    }
  }

  List<Tag> getTags() {
    return authCubit.state.company!.tags;
  }

  Future<List<Tracking>> getTrackings(
      int skip, String clientId, int limit) async {
    AppUser user = authCubit.state.appUser!;
    List<Tracking> resultArray = [];
    print('this far');
    try {
      print(skip);
      QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
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
        Timestamp stop = trackDoc['stop'];
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
