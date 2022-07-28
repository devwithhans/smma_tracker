import 'package:agency_time/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/models/tracking.dart';

import 'package:agency_time/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

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

  Future<String?> updateTracker({
    Duration? duration,
    int? tag,
    required String trackingDocId,
    DateTime? stop,
  }) async {
    AppUser user = authCubit.state.appUser!;

    try {
      Map<String, dynamic> updateObject = {
        'duration': duration != null ? duration.inSeconds : null,
        'tag': tag,
        'finished': true,
      };
      if (stop != null) {
        updateObject.addAll({
          'stop': stop,
        });
      }

      final result = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .collection('trackings')
          .doc(trackingDocId)
          .update(updateObject);

      return "SUCCES";
    } on FirebaseFunctionsException catch (error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }

  Future<String?> deleteTracking({
    required String trackingDocId,
  }) async {
    AppUser user = authCubit.state.appUser!;
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .collection('trackings')
          .doc(trackingDocId)
          .delete();
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

  Future<Client> editClient(Client newValues) async {
    AppUser user = authCubit.state.appUser!;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    print('${DateTime.now().year}-${DateTime.now().month}');
    try {
      await firebaseFirestore
          .collection('companies')
          .doc(user.companyId)
          .collection('clients')
          .doc(newValues.id)
          .update({
        'name': newValues.name,
        'mrr': newValues.mrr,
        'target_hourly_rate': newValues.hourlyRateTarget
      });

      await firebaseFirestore
          .collection('companies')
          .doc(user.companyId)
          .collection('clients')
          .doc(newValues.id)
          .collection('months')
          .doc('2022-7')
          .update(
        {
          'name': newValues.name,
          'mrr': newValues.mrr,
          'target_hourly_rate': newValues.hourlyRateTarget
        },
      );
      return newValues;
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addTag(
      {required String tag,
      required String description,
      required int id}) async {
    AppUser user = authCubit.state.appUser!;

    try {
      // FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

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
