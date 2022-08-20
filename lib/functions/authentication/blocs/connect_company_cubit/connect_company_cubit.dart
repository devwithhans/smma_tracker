import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:equatable/equatable.dart';

part 'connect_company_state.dart';

class ConnectCompanyCubit extends Cubit<ConnectCompanyState> {
  ConnectCompanyCubit() : super(ConnectCompanyInitial());

  Future<void> connectCompany() async {}
  Future<void> acceptInvite(String email) async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    firebaseFunctions.useFunctionsEmulator('localhost', 5001);

    HttpsCallable callable = firebaseFunctions.httpsCallable('acceptInvite');

    try {
      final resp = await callable.call({
        'email': email,
      });
      print(resp.data);
    } on FirebaseFunctionsException catch (error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }
}
