class AppValidator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast venligst en email';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Indtast venligst en gyldig mail';
    }
    return null;
  }
}
