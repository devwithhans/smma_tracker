class SignupPayload {
  SignupPayload(
      {required this.password,
      required this.email,
      required this.name,
      required this.newletter});

  final String password;
  final String email;
  final String name;
  final bool newletter;
}
