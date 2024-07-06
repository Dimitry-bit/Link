import 'package:link/dtos/dto_base.dart';
import 'package:link/models/person.dart';

class PersonDTO implements DTOBase<Person> {
  String? name;
  String? email;
  bool? isDoctor;

  PersonDTO({this.name, this.email, this.isDoctor});

  @override
  bool isValid() {
    return (name?.trim().isNotEmpty ?? false) &&
        (email?.trim().isNotEmpty ?? false) &&
        (isDoctor != null);
  }

  @override
  Person create() => Person(name!, email!, isDoctor!);

  @override
  void mapTo(Person obj) {
    obj.name = name ?? obj.name;
    obj.isDoctor = isDoctor ?? obj.isDoctor;
    obj.email = email ?? obj.email;
  }
}
