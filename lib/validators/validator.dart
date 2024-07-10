abstract class Validator {
  final String name;

  Validator(this.name);

  String? validate(dynamic value);
}
