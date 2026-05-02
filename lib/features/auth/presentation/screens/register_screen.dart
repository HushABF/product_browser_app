import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    Text('Product Browser', style: textTheme.titleLarge),
                    SizedBox(height: 64),
                    EmailAndPasswordAndUsernameForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      usernameController: _usernameController,
                    ),
                    SizedBox(height: 32),

                    AppTextButton(
                      buttonText: 'Create Account',
                      textStyle: textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;
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
                    SizedBox(height: 18),
                    AlreadyHaveAccountText(),
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
