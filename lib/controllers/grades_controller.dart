import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/grade_dto.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';

class GradesController extends CrudController<Grade> {
  final CrudController<Course> _coursesController;

  GradesController(super.repo, CrudController<Course> coursesController)
      : _coursesController = coursesController {
    _coursesController.onUpdated.addListener(_handleCourseUpdate);
    _coursesController.onRemoved.addListener(_handleCourseRemoval);
  }

  @override
  dispose() {
    _coursesController.onUpdated.removeListener(_handleCourseUpdate);
    _coursesController.onRemoved.removeListener(_handleCourseRemoval);

    super.dispose();
  }

  _handleCourseUpdate(Course? oldObj, Response<Course> res) {
    bool keyChanged = res.errorStr.isEmpty &&
        (oldObj != null) &&
        (oldObj.primaryKey() != res.data!.primaryKey());

    if (keyChanged && repo.containsKey(oldObj.primaryKey())) {
      GradeDTO dto = GradeDTO();
      dto.course = res.data!;
      update(oldObj.primaryKey(), dto);
    }
  }

  _handleCourseRemoval(Course obj) {
    removeByKey(obj.primaryKey());
  }
}
