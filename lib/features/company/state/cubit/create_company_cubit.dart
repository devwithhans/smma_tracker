import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/error/error.dart';
import 'package:agency_time/features/company/repository/companyRepo.dart';
import 'package:agency_time/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'create_company_state.dart';

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  CreateCompanyCubit() : super(const CreateCompanyState());
  CompanyRepo companyRepo = CompanyRepo();

  Future<void> createCompany({
    required String name,
    required String countryCode,
    required String userId,
    required String? vatNumber,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      await companyRepo.createCompany(
        name: name,
        countryCode: countryCode,
        userId: userId,
        vatNumber: vatNumber,
      );

      RestartWidget.restartApp(navigatorKey.currentContext!);
      emit(state.copyWith(status: BlocStatus.succes));
    } on FirebaseException catch (error) {
      emit(state.copyWith(
          status: BlocStatus.failed, error: HcError.couldNotCreateCompany));
    }
  }
}
