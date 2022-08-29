import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInRepo {
  SignInRepo();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
      {required String password,
      required String email,
      required String name,
      required bool newletter}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': splitNames(name).first,
        'lastName': splitNames(name).length > 1 ? splitNames(name).last : '',
        'email': email,
        'newletter': newletter
      });
    }
  }

  List<String> splitNames(String fullName) {
    String firstName = fullName.split(' ').first;
    String lastName = fullName.replaceFirst('$firstName ', '');
    return [firstName, lastName];
  }
}
