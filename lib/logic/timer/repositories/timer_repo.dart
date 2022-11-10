import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/models/tag.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TimerRepository {
  AuthorizeCubit authCubit;

  TimerRepository(this.authCubit);

  Future<String?> createTrackingDocumentAndGetId(
      {required Client client, required DateTime start}) async {
    AppUser user = authCubit.state.appUser!;
    try {
      final result = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.companyId)
          .collection('trackings')
          .add(
        {
          'start': start,
          'clientId': client.id,
          'internal': client.internal,
          'userId': user.id,
          'userName': user.firstName,
          'clientName': client.name,
          'finished': false,
        },
      );
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
    }
  }

  Future<void> deleteTracking(String trackingDocId) async {
    AppUser user = authCubit.state.appUser!;

    await FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('trackings')
        .doc(trackingDocId)
        .delete();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> trackerDocumentSubscription(
      String documentId) {
    AppUser user = authCubit.state.appUser!;

    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('trackings')
        .doc(documentId)
        .snapshots();
  }

  Future<StartExistingTimer?> checkForRunningTimer() async {
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
      return StartExistingTimer(
        duration: Duration(seconds: seconds),
        trackingDocumentId: singleResult.id,
        startDate: startTime,
        client: Client(
          name: singleResult['clientName'],
          id: singleResult['clientId'],
        ),
      );
    }
    return null;
  }

  Future<void> addTag(Tag tag) async {
    AppUser user = authCubit.state.appUser!;

    try {
      // FirebaseFirestore.instance.useFirestoreEmulator('localHost', 8080);

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
