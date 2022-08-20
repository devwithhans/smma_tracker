import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewCompanyRepo {
  AuthCubit authCubit;
  NewCompanyRepo(this.authCubit);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
}
