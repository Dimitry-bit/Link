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

  List<Location> getAll() => _repo.data().toList();

  Location? getByName(String name) {
    Iterator<Location> it = _repo.iterator();

    while (it.moveNext()) {
      if (it.current.name == name) {
        return it.current;
      }
    }

    return null;
  }

  Response<Location> create(LocationDTO dto) {
    bool isValid = (dto.name?.trim().isNotEmpty ?? false);

    if (!isValid) {
      return Response.error("couldn't create location, missing data");
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
      Location? location = getByName(name);
      if (location == null) {
        return Response.error("Location '$name' does not exist.");
      }

      if (newData.name != null) {
        location.name = newData.name!;
      }

      if (newData.description != null) {
        location.description = newData.description!;
      }

      notifyListeners();
      return Response(location);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  void removeByName(String name) {
    Location? location = getByName(name);
    if (location != null) {
      _repo.remove(location);
    }
  }

  void _notifyListenersCallback() => notifyListeners();
}
