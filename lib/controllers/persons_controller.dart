import 'package:link/controllers/controller_base.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/person_dto.dart';
import 'package:link/models/person.dart';

class PersonnelController extends ControllerBase<Person> {
  PersonnelController(super.repo);

  Response<Person> create(PersonDTO dto) {
    Response<Person> res;
    bool isValid = (dto.name?.trim().isNotEmpty ?? false) &&
        (dto.email?.trim().isNotEmpty ?? false) &&
        (dto.isDoctor != null);

    if (isValid) {
      if (!repo.containsKey(dto.email!)) {
        try {
          final person = Person(dto.name!, dto.email!, dto.isDoctor!);

          repo.add(person);
          res = Response(person);
        } catch (e) {
          res = Response<Person>.error(e.toString());
        }
      } else {
        res = Response.error("Person {email: ${dto.email!}} already exists");
      }
    } else {
      res = Response.error("Couldn't create person, missing data");
    }

    notifyOnCreateListeners(res);
    return res;
  }

  Response<Person> update(String email, PersonDTO newData) {
    Response<Person> res;
    Person? oldValue = getByKey(email);

    if (oldValue != null) {
      Person newValue = oldValue.clone();

      try {
        newValue.name = newData.name ?? newValue.name;
        newValue.isDoctor = newData.isDoctor ?? newValue.isDoctor;
        newValue.email = newData.email ?? newValue.email;

        bool isKeyChanged = oldValue.primaryKey() != newValue.primaryKey();
        if (!isKeyChanged || !repo.contains(newValue)) {
          repo.update(oldValue.primaryKey(), newValue);
          res = Response(newValue);
        } else {
          res = Response.error(
              "Person {email: ${newValue.email}} already exists");
        }
      } catch (e) {
        res = Response<Person>.error(e.toString());
      }
    } else {
      res = Response.error("Person {email: $email} does not exist");
    }

    notifyOnUpdateListeners(res);
    return res;
  }
}
