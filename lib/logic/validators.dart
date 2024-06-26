bool validateSchoolID(String? schoolID, [String? role]) {
  /// Must check for:
  /// - is numeric
  /// - first two digits
  /// - length
  if (schoolID != null) {
    /// regex for instructor id
    final instructorIDRegex = RegExp(r'^3[0-9]{6}$');

    /// regex for student id
    final studentIDRegex = RegExp(r'^2[0-9]{9}$');

    if (role == 'instructor') {
      bool schoolIDValid = instructorIDRegex.hasMatch(schoolID);
      return schoolIDValid;
    } else if (role == 'student') {
      bool schoolIDValid = studentIDRegex.hasMatch(schoolID);
      return schoolIDValid;
    }
  }

  /// if other role was provided, then it will just return false
  return false;
}

bool validateTotalScore(String? score) {
  if (score != null) {
    /// regex for instructor id
    final RegExp totalScoreRegex = RegExp(r'^(?:[5-9]|[1-9]\d|1\d\d|200)$');
    bool totalScore = totalScoreRegex.hasMatch(score);
    return totalScore;
  }
  return false;
}

bool validateScore(String? score) {
  if (score != null) {
    /// regex for instructor id
    final RegExp scoreRegex = RegExp(r'^(?:[0-9]|[1-9]\d|1\d\d|200)$');
    bool matchScore = scoreRegex.hasMatch(score);
    return matchScore;
  }
  return false;
}

bool validateEmail(String? email) {
  if (email != null) {
    // must have three words,
    // 1st & 2nd connected by '@',
    // 2nd & 3rd connected by '.',
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final bool emailValid = emailRegex.hasMatch(email);
    return emailValid;
  }
  return false;
}

bool validateName(String? name) {
  if (name != null) {
//disallow special chars except for dashes and periods
    // FIX doesn't detect
    final nameRegex = RegExp(r'^([a-zA-Z\.]+([.-]?[a-zA-Z]+)?(\s|$)){1,10}\.?$');
    final bool nameValid = nameRegex.hasMatch(name);
    return nameValid;
  }
  return false;
}

Map<String, bool> validatePassword(String pass) {
  /*
  r'^
  (?=.*[A-Z])       // should contain at least one upper case
  (?=.*[a-z])       // should contain at least one lower case
  (?=.*?[0-9])      // should contain at least one digit
  (?=.*?[!@#\$&*~]) // should contain at least one Special character
  .{8,}             // Must be at least 8 characters in length  
$
*/

//Initialized regexp because recalling can be expensive
  final hasUpper = RegExp(r'^(?=.*[A-Z])');
  final hasLower = RegExp(r'^(?=.*[a-z])');
  final hasDigit = RegExp(r'^(?=.*?[0-9])');
  final length = RegExp(r'^.{8,}$');

  // the caller can identify what is missing in the password
  Map<String, bool> result = {
    'upper': hasUpper.hasMatch(pass),
    'lower': hasLower.hasMatch(pass),
    'digit': hasDigit.hasMatch(pass),
    'length': length.hasMatch(pass),
  };
  return result;
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

//         results['length'] == false ? message += 'at least 8 characters in length\n' : null;

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

//         results['length'] == false ? message += 'at least 8 characters in length\n' : null;

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
