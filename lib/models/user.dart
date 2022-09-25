class AppUser {
  String id;
  String? companyId;
  String firstName;
  String lastName;
  String email;
  String stripeId;

  AppUser({
    required this.id,
    this.companyId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.stripeId,
  });

  static AppUser convert(Map<String, dynamic> value, String uid) {
    return AppUser(
        id: uid,
        stripeId: value['stripeId'] ?? '',
        companyId: value['companyId'],
        firstName: value['firstName'],
        lastName: value['lastName'],
        email: value['email']);
  }
}

class UserData {
  String id;
  String firstName;
  String lastName;
  String email;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  static UserData convert(Map<String, dynamic> value, String uid) {
    return UserData(
        id: uid,
        firstName: value['firstName'],
        lastName: value['lastName'],
        email: value['email']);
  }
}
