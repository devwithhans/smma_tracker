import 'package:agency_time/firebase_options.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/views/add_clients_view.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/statistics/repos/settings_repo.dart';
import 'package:agency_time/functions/payments/web_views/web_new_company/web_new_company.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:agency_time/functions/authentication/views/wrapper.dart';
import 'package:agency_time/utils/error_handling/error_handler.dart';
import 'package:agency_time/views/enter_app_view/web/web_login_view.dart';
import 'package:agency_time/views/enter_app_view/web/web_register_view.dart';
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
  // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  // setUrlStrategy(PathUrlStrategy());

  // FirebaseFirestore.instance.settings = const Settings(
  //   host: 'localhost:8080',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  BlocOverrides.runZoned(
    () => runApp(RestartWidget(child: const MyApp())),
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
                  WebRegisterView.pageName: (context) => WebRegisterView(),
                  WebLoginView.pageName: (context) => WebLoginView(),
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
