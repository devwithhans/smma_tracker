import 'package:agency_time/utils/error_handling/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppErrors {
  static ErrorContent noConnection(User? user, String codePosition) =>
      ErrorContent(
        codePosition: codePosition,
        user: user,
        developerMessage:
            'This happens both when the user do not have any internet, or the server is down.',
        title: 'We could not connect to the servers',
        message:
            'Check if you have internet connection and try again. If problem persist please contact the support,',
      );
}

enum ErrorDisplayType { dialog, screen, simpleNotification }

enum ErrorAction { reload, wait }

class ErrorContent {
  String title;
  String message;
  String codePosition;
  String developerMessage;
  User? user;
  ErrorDisplayType errorDisplayType;
  ErrorAction errorAction;

  ErrorContent({
    this.title = '',
    this.message = '',
    this.codePosition = '',
    this.developerMessage = '',
    this.user,
    this.errorDisplayType = ErrorDisplayType.screen,
    this.errorAction = ErrorAction.reload,
  });
}
