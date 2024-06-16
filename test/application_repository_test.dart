import 'dart:convert';

import 'package:test/test.dart';
import 'package:link/models/location.dart';
import 'package:link/models/person.dart';
import 'package:link/models/time_slot.dart';
import 'package:link/repositories/application_repository.dart';
import 'package:link/models/course.dart';

void main() {
  group('Application Repository, encoding, decoding', () {
    Course course =
        Course('Test Course', 'test101', 'General', 5, 2, true, true, false);
    Location location = Location('Test Location', 'description');
    Person person = Person('Test Person', 'test@example.com', false);
    TimeSlot timeSlot = TimeSlot(course, location, person);

    String jsonStr =
        '{"courses":[{"name":"Test Course","code":"test101","department":"General","creditHours":5,"year":2,"hasLecture":true,"hasLab":true,"hasSection":false}],"locations":[{"name":"Test Location","description":"description"}],"personnel":[{"name":"Test Person","email":"test@example.com","isDoctor":false}],"timeSlots":[{"id":0,"courseCode":"test101","locationName":"Test Location","personEmail":"test@example.com"}]}';

    test('encoding', () {
      ApplicationRepository appRepo = ApplicationRepository();
      appRepo.courses.add(course);
      appRepo.locations.add(location);
      appRepo.personnel.add(person);
      appRepo.timeSlots.add(timeSlot);

      String json = jsonEncode(appRepo.toJson());
      expect(json, jsonStr);
    });

    test('decoding', () {
      ApplicationRepository appRepo =
          ApplicationRepository.fromJson(jsonDecode(jsonStr));

      expect(appRepo.courses.length(), 1);
      expect(appRepo.courses.first(), course);

      expect(appRepo.locations.length(), 1);
      expect(appRepo.locations.first(), location);

      expect(appRepo.personnel.length(), 1);
      expect(appRepo.personnel.first(), person);

      expect(appRepo.timeSlots.length(), 1);
      expect(appRepo.timeSlots.first(), timeSlot);
    });
  });
}
