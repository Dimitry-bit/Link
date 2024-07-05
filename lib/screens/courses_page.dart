import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/courses_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/courses_data_source.dart';
import 'package:link/models/course.dart';
import 'package:link/screens/add_course_form.dart';
import 'package:link/screens/data_grid_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final _gridController = DataGridController();
  late CoursesController _coursesController;
  late CoursesDataSource _coursesSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _coursesController = Provider.of<CoursesController>(context);
    _coursesController.removeOnUpdateListener(_handleControllerError);
    _coursesController.addOnUpdateListener(_handleControllerError);

    _coursesSource = CoursesDataSource(_coursesController);
  }

  @override
  void dispose() {
    _coursesController.removeOnUpdateListener(_handleControllerError);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Courses'),
        DataGridPage(
          controller: _gridController,
          dataSource: _coursesSource,
          columns: CourseColumns.values.map((e) {
            bool sorting = (e.name != CourseColumns.hasLecture.name) &&
                (e.name != CourseColumns.hasLab.name) &&
                (e.name != CourseColumns.hasSection.name);

            return buildGridColumn(
              context,
              e.name,
              allowSorting: sorting,
            );
          }).toList(),
          onPressDelete: () {
            String? code =
                _gridController.selectedRow?.getCells().firstOrNull?.value;

            if (code != null) {
              _coursesController.removeByKey(code);
            }
          },
          onPressAdd: () => showDialog(
            context: context,
            builder: (_) => const Dialog(child: AddCourseForm()),
          ),
          buildSearchFilters: (searchText) => {
            CourseColumns.code.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
              filterOperator: FilterOperator.or,
            ),
            CourseColumns.name.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
              filterOperator: FilterOperator.or,
            ),
          },
        ),
      ],
    );
  }

  void _handleControllerError(Response<Course> res) {
    if (res.errorStr.isNotEmpty) {
      final SnackBar alert = alertSnackBar(
        context,
        res.errorStr,
        AlertTypes.error,
      );

      ScaffoldMessenger.of(context).showSnackBar(alert);
    }
  }
}
