import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/validator_text.g.dart';

@Riverpod()
class TextValidator extends _$TextValidator {
  @override
  TextValidatorState build() => TextValidatorState();

  String? validateDisplayName(String? name) {
    if (name == null || name.isEmpty) return 'Cannot be empty';
    if (state._nameRegex.hasMatch(name)) return null;
    return 'Not a valid name';
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Cannot be empty';
    if (state._emailRegex.hasMatch(email)) return null;
    return 'Not a valid email';
  }

  String? validateMaxPlayers(String? maxPlayers) {
    if (maxPlayers == null || maxPlayers.isEmpty) return 'Cannot be empty';
    if (state._maxPlayers.hasMatch(maxPlayers)) return null;
    return 'Not a valid number';
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP.';
    }

    if (value.length != 6) {
      return 'OTP is 6 digits.';
    }

    if (!state._otpRegex.hasMatch(value)) {
      return 'Only digits are allowed.';
    }

    return null; // If the input passes validation
  }

  String? validatePassword(String? pass) {
    if (pass == null || pass.isEmpty) return 'Cannot be empty';

    /// if empty input

    // the caller can identify what is missing in the password
    // Map<String, bool> result = {
    //   'upper': _hasUpper.hasMatch(pass),
    //   'lower': _hasLower.hasMatch(pass),
    //   'digit': _hasDigit.hasMatch(pass),
    //   'length': _length.hasMatch(pass),
    // };
    return null;
  }

  String? validatePhoneNum(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP.';
    }

    if (value.length != 9) {
      return 'Phone # is 9 digits, excluding the zero.';
    }

    if (!state._phoneNumRegex.hasMatch(value)) {
      return 'Only digits are allowed.';
    }

    return null; // If the input passes validation
  }

  String? validateRoomName(String? name) {
    if (name == null || name.isEmpty) return 'Cannot be empty';
    //if (_emailRegex.hasMatch(email))
    return null;
    // return 'Not a valid email';
  }

  String? validateRoomPass(String? pass) {
    if (pass == null || pass.isEmpty) return 'Cannot be empty';
    //if (_emailRegex.hasMatch(email))
    return null;
    // return 'Not a valid email';
  }

//         if (widget.hintText != null && widget.hintText == value) {
//           return null;
//         }

//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }

//         if (widget.forLogin == true) {
//           return null;
//         }

//         String message = 'Must have:\n';

//         Map<String, bool> results = validatePassword(value);

//         results['upper'] == false ? message += 'at least one uppercase\n' : null;

//         results['lower'] == false ? message += 'at least one lowercase\n' : null;

//         results['digit'] == false ? message += 'at least one digit\n' : null;

//         results['_length'] == false ? message += 'at least 8 characters in _length\n' : null;

//         if (message == 'Must have:\n') {
//           return null;
//         }

//         return message;
}

// TODO: affix this code later
// String? Function(String?)? getValidator() {
//   switch (widget.type ?? widget.labelText) {
//     case 'Total Score':
//       return (value) {
//         if (widget.hintText != null && widget.hintText == value) {
//           return null;
//         }

//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }

//         String? message = validateTotalScore(value) ? null : 'Must be a valid total score';
//         return message;
//       };

//     case 'Email':
//       return (value) {
//         if (widget.hintText != null && widget.hintText == value) {
//           return null;
//         }

//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }

//         String? message = validateEmail(value) ? null : 'Must be a valid email';
//         return message;
//       };

//     case 'New Password':
//       return (value) {
//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }
//         String message = 'Must have:\n';

//         Map<String, bool> results = validatePassword(value);

//         results['upper'] == false ? message += 'at least one uppercase\n' : null;

//         results['lower'] == false ? message += 'at least one lowercase\n' : null;

//         results['digit'] == false ? message += 'at least one digit\n' : null;

//         results['_length'] == false ? message += 'at least 8 characters in _length\n' : null;

//         if (widget.oldPass != null) {
//           if (value.trim() == widget.oldPass!.text.trim()) {
//             return 'New password cannot be the same as \nold password';
//           }
//         }

//         if (message == 'Must have:\n') {
//           return null;
//         }

//         return message;
//       };

//     case 'Password':
//       return (value) {
//         if (widget.hintText != null && widget.hintText == value) {
//           return null;
//         }

//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }

//         if (widget.forLogin == true) {
//           return null;
//         }

//         String message = 'Must have:\n';

//         Map<String, bool> results = validatePassword(value);

//         results['upper'] == false ? message += 'at least one uppercase\n' : null;

//         results['lower'] == false ? message += 'at least one lowercase\n' : null;

//         results['digit'] == false ? message += 'at least one digit\n' : null;

//         results['_length'] == false ? message += 'at least 8 characters in _length\n' : null;

//         if (message == 'Must have:\n') {
//           return null;
//         }

//         return message;
//       };

//     case 'School ID':
//       return (value) {
//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }

//         String? message = validateSchoolID(value, widget.role ?? 'instructor') ? null : 'Must be a valid school ID';

//         return message;
//       };

//     case 'Full Name' || 'Name':
//       return (value) {
//         String? message = validateName(value) ? null : 'Must be a valid name';

//         return message;
//       };

//     default:
//       return (value) {
//         if (value == null || value.isEmpty) {
//           return 'Field cannot be empty';
//         }
//         return null;
//       };
//   }
// }
class TextValidatorState {
  final _emailRegex =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"); // follow email format

  final _nameRegex = RegExp(r'^([a-zA-Z\.]+([.-]?[a-zA-Z]+)?(\s|$)){1,10}\.?$'); // no special symbols
  final _otpRegex = RegExp(r'^\d{6}$');
  final _phoneNumRegex = RegExp(r'^[0-9]+$');
  final _maxPlayers = RegExp(r'^(?:[1-9]|1[0-9]|20)$'); // max 20
}
