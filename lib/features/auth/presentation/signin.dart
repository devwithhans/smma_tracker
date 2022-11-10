import 'package:agency_time/bloc_config.dart';
import 'package:agency_time/features/auth/presentation/widgets/errorText.dart';
import 'package:agency_time/features/auth/state/authenticate/authenticate_cubit.dart';
import 'package:agency_time/utils/constants/validators.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/utils/widgets/buttons/social_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:agency_time/views/view_enter_app/web/widgets/web_hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signin extends StatelessWidget {
  static String pageName = 'signin';

  Signin({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String password = '';
    String email = '';

    return BlocProvider(
      create: (context) => AuthenticateCubit(),
      child: Scaffold(
        body: BlocBuilder<AuthenticateCubit, AuthenticateState>(
          builder: (context, state) {
            print(state.status);
            if (state.status == BlocStatus.loading) {
              return const LoadingScreen();
            }
            return ResponsiveSplitScreen(
              left: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EnterAppHeadline(
                    pushScreen: EnterAppPushScreen.register,
                    title: 'Login',
                    subTitle: 'Login to your account or',
                  ),
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
                          validator: AppValidator.email,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          hintText: 'Enter email',
                        ),
                        const SizedBox(height: 30),
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
                        ErrorText(error: state.error),
                        const SizedBox(height: 40),
                        CustomElevatedButton(
                          text: 'Sign in',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<AuthenticateCubit>()
                                  .signinWithPassword(password, email);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        SocialButton(
                          icon: 'assets/google-logo.png',
                          onPressed: () {
                            context
                                .read<AuthenticateCubit>()
                                .signinWithGoogle();
                          },
                          text: 'Continue with google',
                        ),
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
