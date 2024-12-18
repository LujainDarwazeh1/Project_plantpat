mixin ValidationMixin {
  String? validPhone(String? value) {
    if (value!.length == 10 &&
        (value.startsWith('059') || value.startsWith('056'))) {
    } else if (value.isEmpty) {
      return 'Enter phone number';
    } else {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  bool validatemail(String input) {
//  return input.isNotEmpty && input.contains('@');
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
  }

//
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else {
      final isValid = validateEmail(value);
      if (isValid != null) {
        return null; // Return null if the email is valid
      } else {
        return 'Please enter a valid email address';
      }
    }
  }
}
