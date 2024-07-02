import 'package:flutter/material.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/person_dto.dart';
import 'package:link/models/person.dart';
import 'package:link/repositories/repository.dart';

class PersonnelController extends ChangeNotifier {
  final Repository<Person> _repo;

  PersonnelController(Repository<Person> repo) : _repo = repo {
    _repo.addListener(_notifyListenersCallback);
  }

  @override
  void dispose() {
    _repo.removeListener(() => notifyListeners);
    super.dispose();
  }

  List<Person> getAll() => _repo.data().toList();

  Person? getByEmail(String email) {
    Iterator<Person> it = _repo.iterator();

    while (it.moveNext()) {
      if (it.current.email == email) {
        return it.current;
      }
    }

    return null;
  }

  Response<Person> create(PersonDTO dto) {
    bool isValid = (dto.name?.trim().isNotEmpty ?? false) &&
        (dto.email?.trim().isNotEmpty ?? false) &&
        (dto.isDoctor != null);

    if (!isValid) {
      return Response.error("Couldn't create person, missing data");
    }

    if (getByEmail(dto.email!) != null) {
      return Response.error("Person {email: ${dto.email!}} already exists");
    }

    try {
      final person = Person(dto.name!, dto.email!, dto.isDoctor!);
      _repo.add(person);
      return Response(person);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  Response<Person> update(String email, PersonDTO newData) {
    try {
      Person? person = getByEmail(email);

      if (person == null) {
        return Response.error("Person {email: $email} does not exist");
      }

      if (newData.name != null) {
        person.name = newData.name!;
      }

      if (newData.email != null) {
        if (getByEmail(newData.email!) != null) {
          return Response.error(
              "Person {email: ${newData.email!}} already exists");
        } else {
          person.email = newData.email!;
        }
      }

      if (newData.isDoctor != null) {
        person.isDoctor = newData.isDoctor!;
      }

      notifyListeners();
      return Response(person);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  void removeByEmail(String email) {
    Person? person = getByEmail(email);

    if (person != null) {
      _repo.remove(person);
    }
  }

  void _notifyListenersCallback() => notifyListeners();
}
