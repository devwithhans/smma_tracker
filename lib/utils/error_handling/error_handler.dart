import 'package:agency_time/main.dart';
import 'package:agency_time/utils/error_handling/errors.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ErrorHandler extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) async {
    ErrorContent appError = error as ErrorContent;
    super.onError(bloc, error, stackTrace);
    if (error.user != null) {
      sendSlackMessage(SlackErrorMessage(
          message: error.developerMessage,
          email: error.user!.email ?? 'No Email',
          codePosition: error.codePosition,
          userId: error.user!.uid));
    }
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ErrorScreen(appError: appError),
      ),
    );

    print(error);
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.appError,
    Key? key,
  }) : super(key: key);

  final ErrorContent appError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: SizedBox(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Text(
                    appError.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    appError.message,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class SlackErrorMessage {
  String message;
  String email;
  String userId;
  String? phone;
  String? name;
  String? codePosition;

  SlackErrorMessage({
    required this.message,
    required this.email,
    required this.userId,
    this.name = 'No name avalible',
    this.codePosition = 'No codePosition avalible',
    this.phone = 'No phone availible',
  });
}

sendSlackMessage(SlackErrorMessage slackErrorMessage) {
  //Slack's Webhook URL
  String url =
      'https://hooks.slack.com/services/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';

  //Makes request headers
  Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  String message = """
A user had a error!
UID: ${slackErrorMessage.userId},
Email: ${slackErrorMessage.email},
Phone: ${slackErrorMessage.phone},
Message: ${slackErrorMessage.message},
Code position: ${slackErrorMessage.codePosition},
""";

  var request = {
    'text': message,
  };

  var result = http
      .post(Uri.parse(url), body: json.encode(request), headers: requestHeader)
      .then((response) {});
}
