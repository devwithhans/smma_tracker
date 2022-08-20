import 'package:agency_time/functions/authentication/blocs/login_cubit/login_cubit.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String password = '';
    String email = '';
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Hello',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w600,
                              height: 0.5),
                        ),
                        const Text(
                          'Sign in to your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 40),
                        CustomInputForm(
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
                        state is LoginFailed
                            ? Text(
                                state.errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              )
                            : SizedBox(),
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
