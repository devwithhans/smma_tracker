part of 'new_company_cubit.dart';

enum NewCompanyStatus { loading, failed, initial }

class ManageCompanyState extends Equatable {
  final String companyName;
  final String countyCode;
  final String vatNumber;
  final NewCompanyStatus newCompanyStatus;
  final List<String> invites;

  const ManageCompanyState({
    this.newCompanyStatus = NewCompanyStatus.initial,
    this.companyName = '',
    this.vatNumber = '',
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
      invites: invites ?? this.invites,
      vatNumber: vatNumber ?? this.vatNumber,
      newCompanyStatus: newCompanyStatus ?? this.newCompanyStatus,
      companyName: companyName ?? this.companyName,
      countyCode: countyCode ?? this.countyCode,
    );
  }

  @override
  List<Object> get props =>
      [companyName, countyCode, vatNumber, newCompanyStatus, invites];
}
