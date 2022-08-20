import 'package:agency_time/functions/authentication/repos/new_company_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'new_company_state.dart';

class NewCompanyCubit extends Cubit<NewCompanyState> {
  NewCompanyCubit() : super(NewCompanyState());

  void setStep(int step) {
    emit(state.copyWith(step: step));
  }

  Future<void> createCompany(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentReference<Map<String, dynamic>> result =
          await firestore.collection('companies').add({
        'companyName': state.companyName,
        'countyCode': state.countyCode,
        'members': {'$userId': 'owner'}
      });
      await firestore.collection('users').doc(userId).update({
        'companyId': result.id,
      });
    } on FirebaseException catch (error) {
      // addError(AppError.noConnection(user));

      print(error);
    }
  }

  void updateValues({
    String? countryCode,
    String? companyName,
    String? vatNumber,
  }) {
    emit(state.copyWith(
        companyName: companyName,
        countyCode: countryCode,
        vatNumber: vatNumber));
  }
}
