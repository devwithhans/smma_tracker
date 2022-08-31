import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/clients/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StopWatchRepository {
  AuthCubit authCubit;
  StopWatchRepository(this.authCubit);

  Future<String?> createTrackingDocument(
      {required Client client, required DateTime start}) async {
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
}
