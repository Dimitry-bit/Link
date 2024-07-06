import 'package:link/models/course.dart';
import 'package:link/models/location.dart';
import 'package:link/models/person.dart';
import 'package:link/models/repository_model.dart';

// TODO: Implement DateTime
class TimeSlot implements RepositoryModel<TimeSlot> {
  static int _idGenerator = 0;

  final int _id;
  Course _course;
  Location _location;
  Person _person;

  TimeSlot.initialize(int id, Course course, Location location, Person person)
      : _id = id,
        _course = course,
        _location = location,
        _person = person;

  TimeSlot(Course course, Location location, Person person)
      : this.initialize(_idGenerator++, course, location, person);

  int get id => _id;

  Course get course => _course;
  set course(Course course) => _course = course;

  Location get location => _location;
  set location(Location location) => _location = location;

  Person get person => _person;
  set person(Person person) => _person = person;

  Map<String, dynamic> toJson() => {
        'id': _id,
        'courseCode': _course.code,
        'locationName': _location.name,
        'personEmail': _person.email,
      };

  factory TimeSlot.fromJson(Map<String, dynamic> json, List<dynamic> refs) {
    int id = json['id'] as int;
    String courseCode = json['courseCode'] as String;
    String locationName = json['locationName'] as String;
    String personEmail = json['personEmail'] as String;

    Course? course = refs.firstWhere(
      ((e) => e is Course && e.code == courseCode),
      orElse: () => null,
    );
    Location? location = refs.firstWhere(
      ((e) => e is Location && e.name == locationName),
      orElse: () => null,
    );
    Person? person = refs.firstWhere(
      ((e) => e is Person && e.email == personEmail),
      orElse: () => null,
    );

    bool areValidRefs =
        (course != null) && (location != null) && (person != null);

    if (!areValidRefs) {
      throw ArgumentError(
          'references are invalid or incomplete, could not construct instance');
    }

    if (id > _idGenerator) {
      _idGenerator = id + 1;
    }

    return TimeSlot.initialize(id, course, location, person);
  }

  @override
  String primaryKey() => _id.toString();

  @override
  TimeSlot clone() => TimeSlot.initialize(_id, _course, _location, _person);

  @override
  bool operator ==(Object other) {
    return other is TimeSlot &&
        _id == other.id &&
        _course == other.course &&
        _location == other.location &&
        _person == other.person;
  }

  @override
  int get hashCode {
    return _id.hashCode ^
        _course.hashCode ^
        _location.hashCode ^
        person.hashCode;
  }

  @override
  String toString() {
    return 'Course: ${_course.name}, Location: ${_location.name}, Person: ${_person.name}';
  }
}
