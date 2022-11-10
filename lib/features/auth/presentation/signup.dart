import 'dart:math';
import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/models/signup_payload.dart';
import 'package:agency_time/features/auth/presentation/signin.dart';
import 'package:agency_time/features/auth/presentation/widgets/errorText.dart';
import 'package:agency_time/features/auth/state/authenticate/authenticate_cubit.dart';
import 'package:agency_time/logic/authentication/login_cubit/login_cubit.dart';
import 'package:agency_time/utils/widgets/buttons/social_button.dart';
import 'package:agency_time/utils/widgets/complience.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:agency_time/views/dialog_payment/paymeny_view_dependencies.dart';

import '../../../../utils/widgets/buttons/main_button.dart';

class Signup extends StatelessWidget {
  static const String pageName = 'register';

  Signup({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String password = '';
    String repeatedPassword = '';
    String email = '';
    String name = '';
    bool newsletter = false;

    return BlocProvider(
      create: (context) => AuthenticateCubit(),
      child: Scaffold(
        body: BlocBuilder<AuthenticateCubit, AuthenticateState>(
          builder: (context, state) {
            if (state.status == BlocStatus.loading) {
              return const LoadingScreen();
            }

            return ResponsiveSplitScreen(
                left: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign up now',
                    style: AppTextStyle.boldLarge,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Register your account or',
                        style: AppTextStyle.medium,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Signin.pageName);
                          },
                          child: const Text('login to an existing'))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomInputForm(
                          title: 'Name',
                          onChanged: (v) {
                            name = v;
                          },
                          validator: (value) {
                            if (value == null || value.length < 1) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          hintText: 'First and last name',
                        ),
                        SizedBox(height: 30),
                        CustomInputForm(
                          title: 'Email',
                          onChanged: (v) {
                            email = v;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'Indtast venligst en gyldig mail';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          hintText: 'Enter email',
                        ),
                        SizedBox(height: 30),
                        CustomInputForm(
                          title: 'Password',
                          onChanged: (v) {
                            password = v;
                          },
                          validator: (value) {
                            return validatePassword(value ?? '');
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLines: 1,
                          hintText: 'Enter password',
                        ),
                        SizedBox(height: 30),
                        CustomInputForm(
                          title: 'Repeat password',
                          onChanged: (v) {
                            repeatedPassword = v;
                          },
                          validator: (value) {
                            if (password != repeatedPassword) {
                              return 'Passwords does not match';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLines: 1,
                          hintText: 'Repeat password',
                        ),
                        SizedBox(height: 30),
                        Compliance(
                            text: 'I\'ve read and accept the',
                            buttonText: 'Terms & Conditions',
                            validator: (v) {
                              if (v == false) {
                                return 'You have to accept our terms';
                              }
                            },
                            onChange: (v) {}),
                        SizedBox(height: 30),
                        Compliance(
                          initialValue: !newsletter,
                          text:
                              'I do not want news about ways to optimize my agency',
                          validator: (v) {},
                          onChange: (v) {
                            newsletter = !v;
                          },
                        ),
                        SizedBox(height: 40),
                        CustomElevatedButton(
                          text: 'Register',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthenticateCubit>().registerUser(
                                    registerLoad: SignupPayload(
                                      email: email,
                                      name: name,
                                      newletter: newsletter,
                                      password: password,
                                    ),
                                  );
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        SocialButton(
                          icon: 'assets/google-logo.png',
                          onPressed: () {
                            context
                                .read<AuthenticateCubit>()
                                .signinWithGoogle();
                          },
                          text: 'Continue with google',
                        ),
                        SizedBox(height: 10),
                        ErrorText(error: state.error)
                      ],
                    ),
                  ),
                ],
              ),
            ));
          },
        ),
      ),
    );
  }
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Please enter password';
  } else {
    if (value.length < 7) {
      return 'Password needs to be at least 8 characters';
    } else {
      return null;
    }
  }
}
