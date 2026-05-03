import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/utils/failure_to_message.dart';
import 'package:product_browser_app/core/utils/validators.dart';
import 'package:product_browser_app/core/widgets/app_text_button.dart';
import 'package:product_browser_app/core/widgets/app_text_field.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _initialUsername;
  late final TextEditingController _usernameController;
  bool _canSave = false;
  late final String? _photoUrl;

  final _formKey = GlobalKey<FormState>();

  void _onUsernameChanged() {
    setState(() {
      _canSave =
          _usernameController.text.trim() != _initialUsername &&
          Validators.validateUsername(_usernameController.text.trim()) == null;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    _photoUrl = user.photoUrl;
    _initialUsername = user.username;
    _usernameController = TextEditingController(text: user.username);
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  current is AuthFailure ||
                  (previous is AuthUpdating && current is AuthAuthenticated),
              listener: (context, state) {
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(FailureToMessage.messageFor(state.failure)),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated.')),
                  );
                }
              },
              builder: (context, state) {
                final bool isUpdating = state is AuthUpdating;
                return Column(
                  crossAxisAlignment: .center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl)
                          : null,
                      child: _photoUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: AppTextFormField(
                        controller: _usernameController,
                        hintText: 'Enter a new username',
                        validator: Validators.validateUsername,
                      ),
                    ),
                    SizedBox(height: 32),
                    AppTextButton(
                      buttonText: 'Save',
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      onPressed: (_canSave && !isUpdating)
                          ? () {
                              if (!_formKey.currentState!.validate()) return;
                              final username = _usernameController.text.trim();
                              context.read<AuthBloc>().add(
                                ProfileUpdateRequested(
                                  username: username,
                                  photoUrl: _photoUrl,
                                ),
                              );
                            }
                          : null,
                    ),
                    SizedBox(height: 32),
                    AppTextButton(
                      buttonText: 'Logout',
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      onPressed: isUpdating
                          ? null
                          : () {
                              context.read<AuthBloc>().add(LogoutRequested());
                            },
                    ),
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
