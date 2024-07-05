import 'package:link/validators/validator.dart';

class NotEmptyValidator implements Validator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'is missing';
    }

    return null;
  }
}
