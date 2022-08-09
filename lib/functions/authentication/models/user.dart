class AppUser {
  String id;
  String companyId;
  String firstName;
  String lastName;
  String email;

  AppUser({
    required this.id,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  static AppUser convert(Map<String, dynamic> value, String uid) {
    return AppUser(
        id: uid,
        companyId: value['companyId'],
        firstName: value['firstName'],
        lastName: value['lastName'],
        email: value['email']);
  }
}

class Member {
  String id;
  String firstName;
  String lastName;
  String email;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  static Member convert(Map<String, dynamic> value, String uid) {
    return Member(
        id: uid,
        firstName: value['firstName'],
        lastName: value['lastName'],
        email: value['email']);
  }
}
