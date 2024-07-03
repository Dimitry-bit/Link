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

  List<Person> getAll() => _repo.data();
  Person? getByEmail(String email) => _repo.getByKeyOrNull(email);

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
      Person? oldValue = getByEmail(email);

      if (oldValue == null) {
        return Response.error("Person {email: $email} does not exist");
      }

      Person newValue = oldValue.clone();
      newValue.name = newData.name ?? newValue.name;
      newValue.isDoctor = newData.isDoctor ?? newValue.isDoctor;
      newValue.email = newData.email ?? newValue.email;

      if (oldValue.primaryKey() != newValue.primaryKey() &&
          _repo.contains(newValue)) {
        return Response.error(
            "Person {email: ${newValue.email}} already exists");
      }

      _repo.update(oldValue.primaryKey(), newValue);
      return Response(newValue);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  void remove(Person p) => _repo.remove(p);
  void removeByEmail(String email) => _repo.removeByKey(email);

  void _notifyListenersCallback() => notifyListeners();
}
