import 'package:link/dtos/dto_base.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';

class GradeDTO implements DTOBase<Grade> {
  Course? course;
  GradeTypes? gradeType;

  GradeDTO({this.course, this.gradeType});

  @override
  Grade create() => Grade(gradeType!, course: course!);

  @override
  bool isValid() => (course != null) && (gradeType != null);

  @override
  void mapTo(Grade obj) {
    obj.course = course ?? obj.course;
    obj.type = gradeType ?? obj.type;
  }
}
