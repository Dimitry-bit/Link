import 'package:link/models/repository_model.dart';
import 'package:link/utils/email_utils.dart';

class Person implements RepositoryModel<Person> {
  late String _email;
  String _name;
  bool _isDoctor;

  Person(String name, String email, bool isDoctor)
      : _name = name.trim(),
        _isDoctor = isDoctor {
    _email = email;
  }

  String getPrefixedName() => '${_isDoctor ? "Dr" : "TA"} $_name';

  String get name => _name;
  set name(String name) => _name = name.trim();

  bool get isDoctor => _isDoctor;
  set isDoctor(bool doctor) => _isDoctor = doctor;

  String get email => _email;

  set email(String email) {
    email = email.trim();

    if (!EmailUtils.isValidEmail(email)) {
      throw ArgumentError("'$email' is not a valid email address");
    }

    _email = email;
  }

  Map<String, dynamic> toJson() => {
        'name': _name,
        'email': _email,
        'isDoctor': _isDoctor,
      };

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['name'] as String,
      json['email'] as String,
      json['isDoctor'] as bool,
    );
  }

  @override
  Person clone() => Person(_name, _email, _isDoctor);

  @override
  bool operator ==(Object other) {
    return other is Person &&
        _name == other._name &&
        _email == other._email &&
        _isDoctor == other._isDoctor;
  }

  @override
  int get hashCode => _name.hashCode ^ _email.hashCode ^ _isDoctor.hashCode;

  @override
  String toString() => "${getPrefixedName()}, email: '$_email'";

  @override
  String primaryKey() => _email;
}
