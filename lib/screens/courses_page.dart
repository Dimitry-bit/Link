import 'package:flutter/material.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
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
  late CrudController<Course> _coursesController;
  late CoursesDataSource _coursesSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _coursesController =
        Provider.of<CrudController<Course>>(context, listen: false);
    _coursesSource = CoursesDataSource(_coursesController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Courses'),
        DataGridPage<Course>(
          controller: _gridController,
          dataSource: _coursesSource,
          crudController: _coursesController,
          addForm: const AddCourseForm(),
          keyColumnName: CourseColumns.code.name,
          columns: CourseColumns.values.map((e) {
            bool sorting = (e.name != CourseColumns.lecture.name) &&
                (e.name != CourseColumns.lab.name) &&
                (e.name != CourseColumns.section.name);

            return buildGridColumn(
              context,
              e.name,
              allowSorting: sorting,
            );
          }).toList(),
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
}
