part of 'new_company_cubit.dart';

enum NewCompanyStatus { loading, failed, initial }

class NewCompanyState extends Equatable {
  final String companyName;
  final String countyCode;
  final String vatNumber;
  final int step;
  final NewCompanyStatus newCompanyStatus;

  const NewCompanyState({
    this.newCompanyStatus = NewCompanyStatus.initial,
    this.companyName = '',
    this.vatNumber = '',
    this.step = 0,
    this.countyCode = 'en',
  });

  NewCompanyState copyWith({
    NewCompanyStatus? newCompanyStatus,
    String? companyName,
    String? countyCode,
    String? vatNumber,
    int? step,
  }) {
    return NewCompanyState(
      step: step ?? this.step,
      vatNumber: vatNumber ?? this.vatNumber,
      newCompanyStatus: newCompanyStatus ?? this.newCompanyStatus,
      companyName: companyName ?? this.companyName,
      countyCode: countyCode ?? this.countyCode,
    );
  }

  @override
  List<Object> get props =>
      [step, companyName, countyCode, vatNumber, newCompanyStatus];
}
