import 'package:flutter/material.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
import 'package:link/repositories/repository.dart';

class LocationsController extends ChangeNotifier {
  final Repository<Location> _locationsRepo;

  LocationsController(Repository<Location> locationsRepo)
      : _locationsRepo = locationsRepo {
    _locationsRepo.addListener(_notifyListenersCallback);
  }

  @override
  void dispose() {
    _locationsRepo.removeListener(() => notifyListeners);
    super.dispose();
  }

  List<Location> getAll() => _locationsRepo.data().toList();

  Location? getByName(String name) {
    Iterator<Location> it = _locationsRepo.iterator();

    while (it.moveNext()) {
      if (it.current.name == name) {
        return it.current;
      }
    }

    return null;
  }

  Response<Location> create(LocationDTO locationDTO) {
    bool isValid = (locationDTO.name?.trim().isNotEmpty ?? false);

    if (!isValid) {
      return Response.error("couldn't create location, missing data");
    }

    try {
      final location = Location(
        locationDTO.name!,
        locationDTO.description ?? '');
      _locationsRepo.add(location);
      return Response(location);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  Response<Location> update(Location location, LocationDTO newData) {
    try {
      if (newData.name != null) {
        location.name = newData.name!;
      }

      if (newData.description != null) {
        location.description = newData.description!;
      }

      return Response(location);
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  void removeLocation(Location location) {
    if (_locationsRepo.contains(location)) {
      _locationsRepo.remove(location);
    }
  }

  void removeLocationById(String name) {
    Location? location = getByName(name);
    if (location != null) {
      removeLocation(location);
    }
  }

  void _notifyListenersCallback() {
    notifyListeners();
  }
}
