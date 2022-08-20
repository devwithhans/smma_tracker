import 'dart:html';

import 'package:agency_time/firebase_options.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/web_view/web_new_company/web_new_company.dart';
import 'package:agency_time/functions/authentication/web_view/web_registration.dart';
import 'package:agency_time/functions/authentication/web_view/web_welcome.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/app/repos/settings_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/functions/authentication/views/wrapper.dart';
import 'package:agency_time/utils/error_handling/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setUrlStrategy(PathUrlStrategy());

  // FirebaseFirestore.instance.settings.persistenceEnabled;

  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: ErrorHandler(),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => TrackerRepo(context.read<AuthCubit>())),
          RepositoryProvider(
              create: (context) => SettingsRepo(context.read<AuthCubit>())),
          RepositoryProvider(
              create: (context) => ClientsRepo(context.read<AuthCubit>())),
        ],
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
                  '/': (context) => const Wrapper(),
                  AddClientView.id: (context) => AddClientView(),
                  WebRegistration.pageName: (context) => WebRegistration(),
                  WebWelcome.pageName: (context) => WebWelcome(),
                  WebNewCompany.pageName: (context) => WebNewCompany(),
                  // ClientView.id: (context) => ClientView(),
                },
              ),
            )),
      ),
    );
  }
}
