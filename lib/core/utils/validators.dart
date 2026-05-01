class Validators {
  static final _emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.]+$');
  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  String? validateEmail(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(input.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? input) {
    if (input == null || input.isEmpty) return 'Password is required';
    if (input.length < 6) return 'Password must at least 6 digits';
    return null;
  }

  String? validateUsername(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Username is required';
    }
    if (!_usernameRegex.hasMatch(input.trim())) {
      return 'Enter a valid username, 3–20 characters, letters, numbers, and underscores only';
    }
    return null;
  }
}
