import 'package:agency_time/functions/authentication/blocs/login_cubit/login_cubit.dart';
import 'package:agency_time/functions/authentication/web_view/web_welcome.dart';
import 'package:agency_time/utils/widgets/complience.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebRegistration extends StatelessWidget {
  static const String pageName = 'register';

  WebRegistration({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String password = '';
    String repeatedPassword = '';
    String email = '';
    String name = '';
    bool newsletter = false;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return LoadingScreen();
            }
            return Row(
              children: [
                Expanded(
                  child: Container(
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Register now',
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Register your account or',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, WebWelcome.pageName);
                                    },
                                    child: Text('login to an existing'))
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
                                      print(!v);
                                    },
                                  ),
                                  SizedBox(height: 40),
                                  CustomElevatedButton(
                                    text: 'Register',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginCubit>().registerUser(
                                            password, email, name, newsletter);
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  state is LoginFailed
                                      ? Text(
                                          state.errorMessage,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        image: DecorationImage(
                            image: AssetImage('assets/startimage.jpg'),
                            fit: BoxFit.cover)),
                  ),
                )
              ],
            );
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
