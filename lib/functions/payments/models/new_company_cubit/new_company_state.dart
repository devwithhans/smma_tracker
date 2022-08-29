part of 'new_company_cubit.dart';

enum NewCompanyStatus { loading, failed, initial }

class ManageCompanyState extends Equatable {
  final String companyName;
  final String countyCode;
  final String vatNumber;
  final int step;
  final NewCompanyStatus newCompanyStatus;
  final List<String> invites;

  const ManageCompanyState({
    this.newCompanyStatus = NewCompanyStatus.initial,
    this.companyName = '',
    this.vatNumber = '',
    this.step = 0,
    this.invites = const [],
    this.countyCode = 'en',
  });

  ManageCompanyState copyWith({
    NewCompanyStatus? newCompanyStatus,
    String? companyName,
    String? countyCode,
    String? vatNumber,
    List<String>? invites,
    int? step,
  }) {
    return ManageCompanyState(
      step: step ?? this.step,
      invites: invites ?? this.invites,
      vatNumber: vatNumber ?? this.vatNumber,
      newCompanyStatus: newCompanyStatus ?? this.newCompanyStatus,
      companyName: companyName ?? this.companyName,
      countyCode: countyCode ?? this.countyCode,
    );
  }

  @override
  List<Object> get props =>
      [step, companyName, countyCode, vatNumber, newCompanyStatus, invites];
}
