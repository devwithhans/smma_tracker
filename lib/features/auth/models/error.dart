class HcError {
  final String errorCode;
  final String developerMessage;
  final String frontendMessage;

  HcError({
    required this.errorCode,
    required this.developerMessage,
    required this.frontendMessage,
  });

  static HcError noUserFound = HcError(
    errorCode: 'user-not-found',
    developerMessage: 'A user tried to login with non existing credentials',
    frontendMessage: 'Password or email was incorrect',
  );
  static HcError wrongPassword = HcError(
    errorCode: 'wrong-password',
    developerMessage: 'Password did not match the one in the database',
    frontendMessage: 'Icorrect password',
  );
  static HcError errorConnectingToTheServer = HcError(
    errorCode: 'error-connecting-to-server',
    developerMessage: 'Could not establish conncetion to the server',
    frontendMessage: 'Lost connection',
  );
  static HcError googleSigninFailed = HcError(
    errorCode: 'google-signin-failed',
    developerMessage: 'No idea but it failed when user tried to signin',
    frontendMessage: 'Could not signin using google',
  );
  static HcError emailAlreadyInUse = HcError(
    errorCode: 'email-already-in-use',
    developerMessage: 'The entered email already exists in the database',
    frontendMessage: 'Email is already used',
  );
  static HcError failedToRegisterUser = HcError(
    errorCode: 'failed-to-register-user',
    developerMessage: 'Some unhandled error accured in the signup process',
    frontendMessage: 'Something went wrong try again later',
  );
}
