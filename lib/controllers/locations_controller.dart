import 'package:flutter/material.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
import 'package:link/repositories/repository.dart';

class LocationsController extends ChangeNotifier {
  final Repository<Location> _repo;

  LocationsController(Repository<Location> repo) : _repo = repo {
    _repo.addListener(_notifyListenersCallback);
  }

  @override
  void dispose() {
    _repo.removeListener(() => notifyListeners);
    super.dispose();
  }

  List<Location> getAll() => _repo.data();
  Location? getByName(String name) => _repo.getByKeyOrNull(name);

  Response<Location> create(LocationDTO dto) {
    bool isValid = (dto.name?.trim().isNotEmpty ?? false);

    if (!isValid) {
      return Response.error("Couldn't create location, missing data");
    }

    if (getByName(dto.name!) != null) {
      return Response.error("Location {name: ${dto.name}} already exists");
    }

    try {
      final location = Location(dto.name!, dto.description ?? '');
      _repo.add(location);
      return Response(location);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  Response<Location> update(String name, LocationDTO newData) {
    try {
      Location? oldValue = _repo.getByKeyOrNull(name);

      if (oldValue == null) {
        return Response.error("Location {name: $name} does not exist");
      }

      Location newValue = oldValue.clone();
      newValue.name = newData.name ?? newValue.name;
      newValue.description = newData.description ?? newValue.description;

      if (oldValue.primaryKey() != newValue.primaryKey() &&
          _repo.contains(newValue)) {
        return Response.error(
            "Location {name: ${newValue.name}} already exists");
      }

      _repo.update(oldValue.primaryKey(), newValue);
      return Response(newValue);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  void remove(Location v) => _repo.remove(v);
  void removeByName(String name) => _repo.removeByKey(name);

  void _notifyListenersCallback() => notifyListeners();
}
