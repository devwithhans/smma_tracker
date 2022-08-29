import 'package:agency_time/functions/authentication/blocs/login_cubit/login_cubit.dart';
import 'package:agency_time/functions/authentication/web_view/web_registration.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebWelcome extends StatelessWidget {
  static String pageName = 'welcome';

  WebWelcome({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String password = '';
    String email = '';

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return LoadingScreen();
            }
            return ResponsiveSplitScreen(
              left: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Log In',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Log in to your account or',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, WebRegistration.pageName);
                          },
                          child: Text('create a new account'))
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
                          title: 'Email',
                          onChanged: (v) {
                            email = v;
                          },
                          validator: (value) {
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
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLines: 1,
                          hintText: 'Enter password',
                        ),
                        SizedBox(height: 40),
                        CustomElevatedButton(
                          text: 'Log Ind',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<LoginCubit>()
                                  .loginUser(password, email);
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
            );
          },
        ),
      ),
    );
  }
}
