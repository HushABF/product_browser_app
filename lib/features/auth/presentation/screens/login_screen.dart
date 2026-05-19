import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/core/utils/failure_to_message.dart';
import 'package:product_browser_app/core/widgets/app_text_button.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:product_browser_app/features/auth/presentation/widgets/dont_have_account_text.dart';
import 'package:product_browser_app/features/auth/presentation/widgets/email_and_password_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  Text('Welcome back.', style: TextStyles.font28DarkBlueBold),
                  SizedBox(height: 8.h),
                  Text(
                    'Sign in to continue shopping',
                    style: TextStyles.font15GrayRegular,
                  ),
                  SizedBox(height: 32.h),
                  EmailAndPasswordForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  SizedBox(height: 32.h),
                  BlocSelector<AuthBloc, AuthState, bool>(
                    selector: (state) => state is AuthLoading,
                    builder: (context, isLoading) => AppTextButton(
                      buttonText: 'Sign in',
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;
                              context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: email,
                                  password: password,
                                ),
                              );
                            },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: ColorsManager.moreLightGray),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text('or', style: TextStyles.font13GrayRegular),
                      ),
                      Expanded(
                        child: Divider(color: ColorsManager.moreLightGray),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Center(child: DontHaveAccountText()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
