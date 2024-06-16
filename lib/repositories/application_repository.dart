import 'package:link/models/course.dart';
import 'package:link/models/location.dart';
import 'package:link/models/person.dart';
import 'package:link/models/time_slot.dart';
import 'package:link/repositories/repository.dart';

class ApplicationRepository {
  Repository<Course> _courses = Repository();
  Repository<Location> _locations = Repository();
  Repository<Person> _personnel = Repository();
  Repository<TimeSlot> _timeSlots = Repository();

  ApplicationRepository();

  Repository<Course> get courses => _courses;
  Repository<Location> get locations => _locations;
  Repository<Person> get personnel => _personnel;
  Repository<TimeSlot> get timeSlots => _timeSlots;

  Map<String, dynamic> toJson() => {
        'courses': _courses.toJson(),
        'locations': _locations.toJson(),
        'personnel': _personnel.toJson(),
        'timeSlots': _timeSlots.toJson(),
      };

  factory ApplicationRepository.fromJson(Map<String, dynamic> json) {
    ApplicationRepository appRepo = ApplicationRepository();

    appRepo._courses = Repository.fromJson(json['courses'], Course.fromJson);
    appRepo._locations =
        Repository.fromJson(json['locations'], Location.fromJson);
    appRepo._personnel =
        Repository.fromJson(json['personnel'], Person.fromJson);

    List<dynamic> refs = List.empty(growable: true);
    refs.addAll(appRepo._courses.data());
    refs.addAll(appRepo._locations.data());
    refs.addAll(appRepo._personnel.data());

    appRepo._timeSlots = Repository.fromJson(json['timeSlots'], (e) {
      return TimeSlot.fromJson(e, refs);
    });

    return appRepo;
  }
}
