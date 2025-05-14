class AppValidation {
  // Validation UserName
  static String? validateUsername(String value) {
    if (value.isEmpty) {
      return 'Please enter a username';
    }

    if (value.length < 6 || value.length > 20) {
      return 'Username must be between 6 and 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Username must contain only letters and numbers';
    }

    return null;
  }

// Validation Email
  static bool validateEmail(String value) {
    if (value.isEmpty) {
      return false;
    }

    // Basic email format validation using regular expression
    final RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(value);
  }

  // Validation Password
  static bool validatePassword(String value) {
    // Implement your custom validation rules here
    if (value.isEmpty) {
      return false;
    }

    // Check for minimum length, character complexity, etc.
    if (value.length < 8 ||
        !RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^\w\d]).*$")
            .hasMatch(value)) {
      return false;
    }

    return true;
  }
}
