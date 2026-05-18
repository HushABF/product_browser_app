import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
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
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyles.font17DarkBlueSemiBold),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthUpdatingFailure ||
                (previous is AuthUpdating && current is AuthAuthenticated),
            listener: (context, state) {
              if (state is AuthUpdatingFailure) {
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
                children: [
                  SizedBox(height: 16.h),
                  _ProfileAvatar(
                    photoUrl: _photoUrl,
                    username: _initialUsername,
                  ),
                  SizedBox(height: 32.h),
                  Form(
                    key: _formKey,
                    child: AppTextFormField(
                      controller: _usernameController,
                      hintText: 'Enter a new username',
                      label: 'Username',
                      validator: Validators.validateUsername,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  AppTextButton(
                    buttonText: 'Save',
                    onPressed: (_canSave && !isUpdating)
                        ? () {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
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
                  SizedBox(height: 16.h),
                  AppTextButton(
                    buttonText: 'Logout',
                    backgroundColor: ColorsManager.error,
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
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String username;

  const _ProfileAvatar({required this.photoUrl, required this.username});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorsManager.mainIndigo, ColorsManager.darkIndigo],
            ),
            image: photoUrl != null
                ? DecorationImage(
                    image: NetworkImage(photoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photoUrl == null
              ? Center(
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: TextStyles.font28DarkBlueBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: ColorsManager.backgroundWhite,
              shape: BoxShape.circle,
              border: Border.all(color: ColorsManager.moreLightGray),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 16.sp,
              color: ColorsManager.gray,
            ),
          ),
        ),
      ],
    );
  }
}
