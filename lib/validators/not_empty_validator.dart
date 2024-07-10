import 'package:link/validators/validator.dart';

class NotEmptyValidator extends Validator {
  NotEmptyValidator(super.name);

  @override
  String? validate(dynamic value) {
    if (value == null) {
      return '$name is missing';
    }

    if (value is! String) {
      return '$name is not a string';
    }

    String s = value;
    if (s.isEmpty) {
      return '$name is empty';
    }

    return null;
  }
}
