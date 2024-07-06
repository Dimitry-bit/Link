import 'package:link/models/repository_model.dart';

class Location implements RepositoryModel<Location> {
  String _name;
  String _description;

  Location(String name, String description)
      : _name = name.trim(),
        _description = description.trim();

  String get name => _name;
  set name(String name) => _name = name.trim();

  String get description => _description;
  set description(String description) => _description = description.trim();

  Map<String, dynamic> toJson() => {
        'name': _name,
        'description': _description,
      };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      json['name'] as String,
      json['description'] as String,
    );
  }

  @override
  Location clone() => Location(_name, _description);

  @override
  bool operator ==(Object other) {
    return other is Location &&
        _name == other._name &&
        _description == other._description;
  }

  @override
  int get hashCode => _name.hashCode ^ _description.hashCode;

  @override
  String toString() => "$_name, description: '$description'";

  @override
  String primaryKey() => _name;
}
