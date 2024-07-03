import 'package:link/controllers/controller_base.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';

class LocationsController extends ControllerBase<Location> {
  LocationsController(super.repo);

  Response<Location> create(LocationDTO dto) {
    Response<Location> res;
    bool isValid = (dto.name?.trim().isNotEmpty ?? false);

    if (isValid) {
      if (!repo.containsKey(dto.name!)) {
        try {
          final location = Location(dto.name!, dto.description ?? '');

          repo.add(location);
          res = Response(location);
        } catch (e) {
          res = Response<Location>.error(e.toString());
        }
      } else {
        res = Response.error("Location {name: ${dto.name}} already exists");
      }
    } else {
      res = Response.error("Couldn't create location, missing data");
    }

    notifyOnCreateListeners(res);
    return res;
  }

  Response<Location> update(String name, LocationDTO newData) {
    Response<Location> res;
    Location? oldValue = getByKey(name);

    if (oldValue != null) {
      Location newValue = oldValue.clone();

      try {
        newValue.name = newData.name ?? newValue.name;
        newValue.description = newData.description ?? newValue.description;

        bool isKeyChange = (oldValue.primaryKey() != newValue.primaryKey());
        if (!isKeyChange || !repo.contains(newValue)) {
          repo.update(oldValue.primaryKey(), newValue);
          res = Response(newValue);
        } else {
          res = Response.error(
              "Location {name: ${newValue.name}} already exists");
        }
      } catch (e) {
        res = Response<Location>.error(e.toString());
      }
    } else {
      res = Response.error("Location {name: $name} does not exist");
    }

    notifyOnUpdateListeners(res);
    return res;
  }
}
