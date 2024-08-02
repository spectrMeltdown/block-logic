import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/validator_text.g.dart';

@Riverpod()
class TextValidator extends _$TextValidator {
  @override
  TextValidator build() => TextValidator();

  // must have three words,
  // 1st & 2nd connected by '@',
  // 2nd & 3rd connected by '.',
  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //disallow special chars except for dashes and periods
  final _nameRegex = RegExp(r'^([a-zA-Z\.]+([.-]?[a-zA-Z]+)?(\s|$)){1,10}\.?$');

/*
  r'^
  (?=.*[A-Z])       // should contain at least one upper case
  (?=.*[a-z])       // should contain at least one lower case
  (?=.*?[0-9])      // should contain at least one digit
  (?=.*?[!@#\$&*~]) // should contain at least one Special character
  .{8,}             // Must be at least 8 characters in _length  
  */

// Initialized regexp because recalling can be expensive
// separated to provide different error text for different missing elements
  // final _hasUpper = RegExp(r'^(?=.*[A-Z])');
  // final _hasLower = RegExp(r'^(?=.*[a-z])');
  // final _hasDigit = RegExp(r'^(?=.*?[0-9])');
  // final _length = RegExp(r'^.{8,}$');

// bool validateTotalScore(String? score) {
//   if (score != null) {
//     /// regex for instructor id
//     final RegExp totalScoreRegex = RegExp(r'^(?:[5-9]|[1-9]\d|1\d\d|200)$');
//     bool totalScore = totalScoreRegex.hasMatch(score);
//     return totalScore;
//   }
//   return false;
// }

// bool validateScore(String? score) {
//   if (score != null) {
//     /// regex for instructor id
//     final RegExp scoreRegex = RegExp(r'^(?:[0-9]|[1-9]\d|1\d\d|200)$');
//     bool matchScore = scoreRegex.hasMatch(score);
//     return matchScore;
//   }
//   return false;
// }

// return a string or a null
  String? validateEmail(String? email) {
    /// if blank input
    if (email == null || email.isEmpty) return 'Cannot be empty';

    /// if matches requirements
    if (_emailRegex.hasMatch(email)) return null;

    /// if doesn't match requirements
    return 'Not a valid email';
  }

  String? validateDisplayName(String? name) {
    /// if blank imput
    if (name == null || name.isEmpty) return 'Cannot be empty';

    /// if matches requirements
    if (_nameRegex.hasMatch(name)) return null;

    /// if doesn't match requirements
    return 'Not a valid name';
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
