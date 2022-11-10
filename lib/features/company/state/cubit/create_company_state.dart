part of 'create_company_cubit.dart';

class CreateCompanyState extends Equatable {
  const CreateCompanyState({this.status = BlocStatus.initial, this.error});
  final BlocStatus status;
  final HcError? error;

  CreateCompanyState copyWith({
    BlocStatus? status,
    HcError? error,
  }) {
    return CreateCompanyState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List get props => [error, status];
}
