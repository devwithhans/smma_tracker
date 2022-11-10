import 'package:agency_time/logic/authentication/login_cubit/login_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInRepo {
  SignInRepo();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registerUser({required RegisterLoad registerLoad}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: registerLoad.email, password: registerLoad.password);

    if (userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': splitNames(registerLoad.name).first,
        'lastName': splitNames(registerLoad.name).length > 1
            ? splitNames(registerLoad.name).last
            : '',
        'email': registerLoad.email,
        'newletter': registerLoad.newletter
      });
    }
  }

  List<String> splitNames(String fullName) {
    String firstName = fullName.split(' ').first;
    String lastName = fullName.replaceFirst('$firstName ', '');
    return [firstName, lastName];
  }
}
