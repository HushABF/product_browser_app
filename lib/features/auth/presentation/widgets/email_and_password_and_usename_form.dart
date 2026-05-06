import 'package:flutter/material.dart';
import 'package:product_browser_app/core/utils/validators.dart';
import 'package:product_browser_app/core/widgets/app_text_field.dart';

class EmailAndPasswordAndUsernameForm extends StatefulWidget {
  const EmailAndPasswordAndUsernameForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController usernameController,
  }) : _usernameController = usernameController,
       _formKey = formKey,
       _emailController = emailController,
       _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _usernameController;

  @override
  State<EmailAndPasswordAndUsernameForm> createState() =>
      _EmailAndPasswordAndUsernameFormState();
}

class _EmailAndPasswordAndUsernameFormState
    extends State<EmailAndPasswordAndUsernameForm> {
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
          SizedBox(height: 32),
          AppTextFormField(
            controller: widget._usernameController,
            hintText: 'Username',
            validator: Validators.validateUsername,
          ),
        ],
      ),
    );
  }
}
