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

  Map<String, dynamic> clientPrices = {
    "1a1pqXjVuYEXTO2g5Xey": [
      {
        "updated": DateTime(2022, 11, 1),
        "services": {
          "123456789": 5000,
        }
      }
    ],
    "VLfiZqBXH1NjpoadaNzl": [
      {
        "updated": DateTime(2022, 11, 1),
        "services": {
          "123456789": 5000,
        }
      }
    ]
  };

  void processData() async {
    AppUser user = authCubit.state.appUser!;
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection('companies')
        .doc(user.companyId)
        .collection('days')
        .where('day', isGreaterThan: DateTime(2021, 11, 1))
        .get();

    List<ClientData> clientsData = [];

    result.docs.forEach((element) {
      Map data = element.data();

      print(
          '__________________________________________________________________________________________________________________________________________________________');

      String clientId = data['clientId'];

      List<dynamic> incomeChanges = clientPrices[clientId];

      DateTime dayDate = data['day'].toDate();

      Map revenue = incomeChanges.firstWhere((element) {
        DateTime incomeDate = element['updated'];
        return incomeDate.month + incomeDate.year ==
            dayDate.month + dayDate.year;
      });

      print(revenue);

      double price = 0;

      clientsData.add(ClientData(
          clientId: data['clientId'],
          tag: data['tag'],
          duration: data['duration'],
          revenue: price));
    });
  }
}

class ClientData {
  ClientData({
    required this.clientId,
    required this.tag,
    required this.duration,
    required this.revenue,
    this.service,
  });

  int duration;
  double revenue;
  String tag;
  String? service;
  String clientId;
}
