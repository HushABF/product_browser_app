import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(FailureToMessage.messageFor(state.failure)),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    Center(
                      child: Text(
                        'Product Browser',
                        style: textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(height: 64),
                    EmailAndPasswordForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    SizedBox(height: 32),
                    AppTextButton(
                      buttonText: 'Sign in',
                      textStyle: textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;
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
                    SizedBox(height: 18),
                    DontHaveAccountText(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
