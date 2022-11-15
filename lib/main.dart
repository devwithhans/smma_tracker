import 'dart:async';
import 'package:agency_time/features/auth/handleAuthStatus.dart';
import 'package:agency_time/features/auth/presentation/signin.dart';
import 'package:agency_time/features/auth/presentation/signup.dart';
import 'package:agency_time/features/auth/state/authorize/authorize_cubit.dart';
import 'package:agency_time/features/client/repository/client_repo.dart';
import 'package:agency_time/firebase_options.dart';
import 'package:agency_time/logic/settings/repos/settings_repo.dart';
import 'package:agency_time/logic/data_visualisation/repos/data_repository.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/views/view_register_company/web/web_register_company_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseAuth.instance
      .useAuthEmulator('localhost', 9099)
      .onError((error, stackTrace) => null);
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  setUrlStrategy(PathUrlStrategy());

  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  runApp(
    const RestartWidget(
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthorizeCubit(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) =>
                  TimerRepository(context.read<AuthorizeCubit>())),
          RepositoryProvider(
              create: (context) =>
                  DataRepository(context.read<AuthorizeCubit>())),
          RepositoryProvider(
              create: (context) =>
                  SettingsRepo(context.read<AuthorizeCubit>())),
          RepositoryProvider(
              create: (context) =>
                  NewClientRepo(context.read<AuthorizeCubit>())),
        ],
        child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: OverlaySupport.global(
              child: MaterialApp(
                color: Colors.white,
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
                  '/': (context) => const HandleAuthStatus(),
                  Signup.pageName: (context) => Signup(),
                  Signin.pageName: (context) => Signin(),

                  WebNewCompany.pageName: (context) => const WebNewCompany(),
                  // ClientView.id: (context) => ClientView(),
                },
              ),
            )),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({required this.child, Key? key}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
