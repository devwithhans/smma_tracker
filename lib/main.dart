import 'package:agency_time/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/firebase_options.dart';
import 'package:agency_time/mobile_views/add_clients_view.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:agency_time/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(),
        child: RepositoryProvider(
          create: (context) => TrackerRepository(context.read<AuthCubit>()),
          child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: OverlaySupport.global(
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  title: 'SMMA Tracker',
                  theme: ThemeData(
                    fontFamily: 'Poppins',
                    backgroundColor: Colors.white,
                    primarySwatch: Colors.blue,
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black),
                    ),
                  ),
                  routes: {
                    '/': (context) => Wrapper(),
                    AddClientView.id: (context) => AddClientView(),
                    // ClientView.id: (context) => ClientView(),
                  },
                ),
              )),
        ));
  }
}
