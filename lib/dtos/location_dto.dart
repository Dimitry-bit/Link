import 'package:link/dtos/dto_base.dart';
import 'package:link/models/location.dart';

class LocationDTO implements DTOBase<Location> {
  String? name;
  String? description;

  LocationDTO({this.name, this.description});

  @override
  bool isValid() => (name?.trim().isNotEmpty ?? false);

  @override
  Location create() => Location(name!, description ?? '');

  @override
  void mapTo(Location obj) {
    obj.name = name ?? obj.name;
    obj.description = description ?? obj.description;
  }
}
