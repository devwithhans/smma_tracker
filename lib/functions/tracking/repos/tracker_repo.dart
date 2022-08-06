import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';

import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TrackerRepo {
  AuthCubit authCubit;
  TrackerRepo(this.authCubit);

  Future<String?> beginTracking(
      {required ClientLite client, required DateTime start}) async {
    AppUser user = authCubit.state.appUser!;

    try {
      final result = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .collection('trackings')
          .add({
        'start': start,
        'clientId': client.id,
        'internal': client.internal,
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
    Tag? newTag,
    required String trackingDocId,
    DateTime? stop,
  }) async {
    AppUser user = authCubit.state.appUser!;
    if (newTag != null) {
      if (authCubit.state.company!.tags
          .where((element) => element.id == newTag.id)
          .isEmpty) {
        addTag(newTag);
      }
    }
    try {
      Map<String, dynamic> updateObject = {
        'duration': duration != null ? duration.inSeconds : null,
        'tag': newTag != null ? newTag.id : tag,
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> trackerSubscription(
      String documentId) {
    AppUser user = authCubit.state.appUser!;

    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('trackings')
        .doc(documentId)
        .snapshots();
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
        client: ClientLite(
          id: singleResult['clientId'],
          name: singleResult['clientName'],
          internal: singleResult['internal'],
        ),
      );
    }
    return null;
  }

  Future<void> addTag(Tag tag) async {
    AppUser user = authCubit.state.appUser!;

    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

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
}
