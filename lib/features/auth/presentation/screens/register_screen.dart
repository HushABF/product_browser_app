import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/core/utils/failure_to_message.dart';
import 'package:product_browser_app/core/widgets/app_text_button.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:product_browser_app/features/auth/presentation/widgets/already_have_account_text.dart';
import 'package:product_browser_app/features/auth/presentation/widgets/email_and_password_and_usename_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(FailureToMessage.messageFor(state.failure)),
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  Center(
                    child: Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: ColorsManager.mainIndigo,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'H',
                          style: TextStyles.font28DarkBlueBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text('Create account.', style: TextStyles.font28DarkBlueBold),
                  SizedBox(height: 8.h),
                  Text(
                    'Join Hush Market today',
                    style: TextStyles.font15GrayRegular,
                  ),
                  SizedBox(height: 32.h),
                  EmailAndPasswordAndUsernameForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    usernameController: _usernameController,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                    style: TextStyles.font12LightGrayMedium,
                  ),
                  SizedBox(height: 24.h),
                  BlocSelector<AuthBloc, AuthState, bool>(
                    selector: (state) => state is AuthLoading,
                    builder: (context, isLoading) => AppTextButton(
                      buttonText: 'Create Account',
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;
                              final username = _usernameController.text.trim();
                              context.read<AuthBloc>().add(
                                RegisterRequested(
                                  email: email,
                                  password: password,
                                  username: username,
                                ),
                              );
                            },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Center(child: AlreadyHaveAccountText()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
