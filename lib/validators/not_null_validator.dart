import 'package:link/validators/validator.dart';

class NotNullValidator extends Validator {
  NotNullValidator(super.name);

  @override
  String? validate(dynamic value) {
    if (value == null) {
      return '$name is missing';
    }

    return null;
  }
}
