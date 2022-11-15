import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/models/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewClientRepo {
  AuthorizeCubit authCubit;
  NewClientRepo(this.authCubit);

  Stream<QuerySnapshot<Map<String, dynamic>>> clientsSubscription() {
    AppUser user = authCubit.state.appUser!;
    return FirebaseFirestore.instance
        .collection('companies')
        .doc(user.companyId)
        .collection('clients')
        .snapshots();
  }

  Client getClientFromFirestoreResult(
      QueryDocumentSnapshot<Map<String, dynamic>> client) {
    return Client.fromFirestoreResult(client, authCubit.state.company!);
  }

  List<Tag> getTags() {
    return authCubit.state.company!.tags;
  }
}
