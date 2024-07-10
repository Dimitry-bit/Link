import 'package:link/validators/validator.dart';

class IntValidator extends Validator {
  IntValidator(super.name);

  @override
  String? validate(dynamic value) {
    if (value == null) {
      return '$name is missing';
    }

    if (value is String) {
      int? intValue = int.tryParse(value);
      if (intValue == null) {
        return '$name is not an integer';
      }
    } else {
      return '$name is not an integer';
    }

    return null;
  }
}
