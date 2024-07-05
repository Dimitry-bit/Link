import 'package:link/controllers/controller_base.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/course_dto.dart';
import 'package:link/models/course.dart';

class CoursesController extends ControllerBase<Course> {
  CoursesController(super.repo);

  Response<Course> create(CourseDTO dto) {
    Response<Course> res;
    bool isValid = (dto.code?.trim().isNotEmpty ?? false) &&
        (dto.name?.trim().isNotEmpty ?? false) &&
        (dto.creditHours != null) &&
        (dto.year != null);

    if (isValid) {
      if (!repo.containsKey(dto.code!)) {
        try {
          final course = Course(
            dto.name!,
            dto.code!,
            dto.department ?? '',
            dto.creditHours!,
            dto.year!,
            dto.hasLecture ?? false,
            dto.hasLab ?? false,
            dto.hasSection ?? false,
          );

          repo.add(course);
          res = Response(course);
        } catch (e) {
          res = Response.error(e.toString());
        }
      } else {
        res = Response.error("Course {code: ${dto.code!}} already exists");
      }
    } else {
      res = Response.error("Couldn't create course, missing data");
    }

    notifyOnCreateListeners(res);
    return res;
  }

  Response<Course> update(String code, CourseDTO newData) {
    Response<Course> res;
    Course? oldValue = getByKey(code);

    if (oldValue != null) {
      Course newValue = oldValue.clone();

      try {
        newValue.code = newData.code ?? newValue.code;
        newValue.name = newData.name ?? newValue.name;
        newValue.department = newData.department ?? newValue.department;
        newValue.creditHours = newData.creditHours ?? newValue.creditHours;
        newValue.year = newData.year ?? newValue.year;
        newValue.hasLecture = newData.hasLecture ?? newValue.hasLecture;
        newValue.hasLab = newData.hasLab ?? newValue.hasLab;
        newValue.hasSection = newData.hasSection ?? newValue.hasSection;

        bool isKeyChange = (oldValue.primaryKey() != newValue.primaryKey());
        if (!isKeyChange || !repo.contains(newValue)) {
          repo.update(oldValue.primaryKey(), newValue);
          res = Response(newValue);
        } else {
          res =
              Response.error("Course {code: ${newValue.code}} already exists");
        }
      } catch (e) {
        res = Response.error(e.toString());
      }
    } else {
      res = Response.error("Course {code: $code} does not exist");
    }

    notifyOnUpdateListeners(res);
    return res;
  }
}
