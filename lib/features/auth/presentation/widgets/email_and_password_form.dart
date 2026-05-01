import 'package:flutter/material.dart';
import 'package:product_browser_app/core/utils/validators.dart';
import 'package:product_browser_app/core/widgets/app_text_field.dart';

class EmailAndPasswordForm extends StatelessWidget {
  const EmailAndPasswordForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey, _emailController = emailController, _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
    
      child: Column(
        children: [
          AppTextFormField(
            controller: _emailController,
            hintText: 'Email',
            validator: Validators.validateEmail,
          ),
          SizedBox(height: 32),
          AppTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            isObscureText: true,
            validator: Validators.validatePassword,
          ),
        ],
      ),
    );
  }
}
