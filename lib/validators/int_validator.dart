import 'package:link/validators/validator.dart';

class IntValidator implements Validator {
  final Validator? _validator;

  IntValidator(Validator? validator) : _validator = validator;

  @override
  String? validate(String? value) {
    String? validation = _validator?.validate(value);
    if (validation != null) {
      return validation;
    }

    int? intValue = int.tryParse(value!);
    if (intValue == null) {
      return 'must be an integer';
    }

    return null;
  }
}
