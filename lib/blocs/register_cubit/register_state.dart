part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, failed, succes }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final int step;
  final String? email;
  final String? password;
  final String? name;
  final String? companyName;
  final String? errorMessage;
  final String? vat;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.step = 1,
    this.companyName,
    this.vat,
    this.email,
    this.name,
    this.password,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    int? step,
    String? email,
    String? password,
    String? errorMessage,
    String? name,
    String? companyName,
    String? vat,
  }) {
    return RegisterState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      step: step ?? this.step,
      vat: vat ?? this.vat,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        step,
        email,
        password,
        name,
        companyName,
        vat,
      ];
}
