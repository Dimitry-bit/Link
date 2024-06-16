import 'dart:convert';

import 'package:test/test.dart';
import 'package:link/models/course.dart';
import 'package:link/repositories/repository.dart';

void main() {
  group('Repository, encoding, decoding', () {
    Course course =
        Course('Test Course', 'test101', 'General', 5, 2, true, true, false);
    String jsonStr = '[{"name":"Test Course","code":"test101",'
        '"department":"General","creditHours":5,"year":2,'
        '"hasLecture":true,"hasLab":true,"hasSection":false}]';

    test('encoding', () {
      Repository<Course> coursesRepo = Repository();
      coursesRepo.add(course);

      String json = jsonEncode(coursesRepo.toJson().toList());
      expect(json, jsonStr);
    });

    test('decoding', () {
      List<dynamic> jsonArray = jsonDecode(jsonStr);
      Repository<Course> coursesRepo =
          Repository.fromJson(jsonArray, Course.fromJson);

      expect(coursesRepo.length(), 1);
      expect(coursesRepo.first(), course);
    });
  });
}
