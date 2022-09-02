import 'package:agency_time/logic/authentication/login_cubit/login_cubit.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/constants/validators.dart';
import 'package:agency_time/utils/widgets/custom_button.dart';
import 'package:agency_time/utils/widgets/custom_input_form.dart';
import 'package:agency_time/utils/widgets/loading_screen.dart';
import 'package:agency_time/utils/widgets/responsive_widgets/splitscreen.dart';
import 'package:agency_time/views/enter_app_view/web/widgets/web_hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebLoginView extends StatelessWidget {
  static String pageName = 'login';

  WebLoginView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String password = '';
    String email = '';

    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: Scaffold(
        body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is LoginLoading) {
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
                        const SizedBox(height: 40),
                        CustomElevatedButton(
                          text: 'Log Ind',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<AuthenticationCubit>()
                                  .loginUser(password, email);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        state is LoginFailed
                            ? Text(
                                state.errorMessage,
                                textAlign: TextAlign.center,
                                style: AppTextStyle.smallRed,
                              )
                            : const SizedBox(),
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
