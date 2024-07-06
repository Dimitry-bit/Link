import 'package:link/dtos/dto_base.dart';
import 'package:link/models/course.dart';

class CourseDTO implements DTOBase<Course> {
  String? name;
  String? code;
  String? department;
  int? creditHours;
  int? year;
  bool? hasLecture;
  bool? hasLab;
  bool? hasSection;

  CourseDTO({
    this.name,
    this.code,
    this.department,
    this.creditHours,
    this.year,
    this.hasLecture,
    this.hasLab,
    this.hasSection,
  });

  @override
  bool isValid() {
    return (code?.trim().isNotEmpty ?? false) &&
        (name?.trim().isNotEmpty ?? false) &&
        (creditHours != null) &&
        (year != null);
  }

  @override
  Course create() {
    return Course(
      name!,
      code!,
      department ?? '',
      creditHours!,
      year!,
      hasLecture ?? false,
      hasLab ?? false,
      hasSection ?? false,
    );
  }

  @override
  void mapTo(Course obj) {
    obj.code = code ?? obj.code;
    obj.name = name ?? obj.name;
    obj.department = department ?? obj.department;
    obj.creditHours = creditHours ?? obj.creditHours;
    obj.year = year ?? obj.year;
    obj.hasLecture = hasLecture ?? obj.hasLecture;
    obj.hasLab = hasLab ?? obj.hasLab;
    obj.hasSection = hasSection ?? obj.hasSection;
  }
}
