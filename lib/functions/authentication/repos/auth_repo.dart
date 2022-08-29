import 'dart:io';

import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/invite.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class AuthRepo {
  AuthRepo();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<AppUser>? getUserDocument(
    String uid,
  ) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      DocumentSnapshot userDocument =
          await users.doc(uid).get().timeout(Duration(seconds: 10));
      return AppUser.convert(userDocument.data() as Map<String, dynamic>, uid);
    } on FirebaseException catch (error) {
      rethrow;
    }
  }

  Future<Company> getCompany(AppUser user) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> companyRaw =
          await FirebaseFirestore.instance
              .collection('companies')
              .doc(user.companyId)
              .get();
      Company company = Company.convert(companyRaw.data()!, companyRaw.id);
      List<Member> members = [];

      List rolesKeys = company.roles.keys.toList();

      for (var key in rolesKeys) {
        DocumentSnapshot<Map<String, dynamic>> member =
            await FirebaseFirestore.instance.collection('users').doc(key).get();
        members.add(Member.convert(member.data()!, key));
      }

      company = company.copyWith(members: members);

      return company;
    } on FirebaseFunctionsException catch (error) {
      rethrow;
    }
  }

  Future<Invite?> checkForInvites(String email) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> inviteRaw = await FirebaseFirestore
          .instance
          .collection('invites')
          .doc(email)
          .get();
      Invite? invite;
      if (inviteRaw.data() != null) {
        invite = Invite.convert(inviteRaw.data()!, inviteRaw.id);
      }

      return invite;
    } on FirebaseFunctionsException catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> checkWifiConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      showSimpleNotification(
        const Text(
          'You are currently offline',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 10),
        background: kColorYellow,
      );
    }
  }

  Future<void> acceptInvite(String email) async {
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    firebaseFunctions.useFunctionsEmulator('localhost', 5001);

    HttpsCallable callable = firebaseFunctions.httpsCallable('acceptInvite');

    try {
      final resp = await callable.call({
        'email': email,
      });
      print(resp.data);
    } on FirebaseFunctionsException catch (error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }
}
