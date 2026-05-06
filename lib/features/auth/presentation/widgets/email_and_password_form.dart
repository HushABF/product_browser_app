import 'package:flutter/material.dart';
import 'package:product_browser_app/core/utils/validators.dart';
import 'package:product_browser_app/core/widgets/app_text_field.dart';

class EmailAndPasswordForm extends StatefulWidget {
  const EmailAndPasswordForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _formKey = formKey,
       _emailController = emailController,
       _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  State<EmailAndPasswordForm> createState() => _EmailAndPasswordFormState();
}

class _EmailAndPasswordFormState extends State<EmailAndPasswordForm> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,

      child: Column(
        children: [
          AppTextFormField(
            controller: widget._emailController,
            hintText: 'Email',
            validator: Validators.validateEmail,
          ),
          SizedBox(height: 32),
          AppTextFormField(
            controller: widget._passwordController,
            hintText: 'Password',
            isObscureText: isObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: Validators.validatePassword,
          ),
        ],
      ),
    );
  }
}
