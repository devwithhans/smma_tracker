import 'package:agency_time/features/auth/models/signup_payload.dart';
import 'package:agency_time/features/auth/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticateRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registerUser({required SignupPayload registerLoad}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: registerLoad.email, password: registerLoad.password);

    if (userCredential.user != null) {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': splitNames(registerLoad.name).first,
        'lastName': splitNames(registerLoad.name).length > 1
            ? splitNames(registerLoad.name).last
            : '',
        'email': registerLoad.email,
        'newletter': registerLoad.newletter
      });
    }
  }

  Future<void> loginUser(String password, String email) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    await FirebaseAuth.instance
        .signInWithRedirect(googleProvider)
        .catchError((e) {
      print(e);
      return null;
    });
    UserCredential userCredential =
        await FirebaseAuth.instance.getRedirectResult();

    print('userCredential.additionalUserInfo');
    print(userCredential.additionalUserInfo);
    // return userCredential;
  }

  Future<AppUser?> createUserWithOauth(User user) async {
    List<String> splitName = splitNames(user.displayName!);

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'firstName': splitName.first,
      'lastName': splitName.length > 1 ? splitName.last : '',
      'email': user.email,
      'photo_url': user.photoURL,
      'newletter': false
    });
  }

  List<String> splitNames(String fullName) {
    String firstName = fullName.split(' ').first;
    String lastName = fullName.replaceFirst('$firstName ', '');
    return [firstName, lastName];
  }
}
