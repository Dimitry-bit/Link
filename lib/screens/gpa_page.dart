import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/gpa_gauge.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/grades_data_source.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';
import 'package:link/screens/add_grade_form.dart';
import 'package:link/screens/data_grid_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GPAPage extends StatefulWidget {
  const GPAPage({super.key});

  @override
  State<GPAPage> createState() => _GPAPageState();
}

class _GPAPageState extends State<GPAPage> {
  final _gridController = DataGridController();
  late CrudController<Grade> _gradesController;
  late GradesDataSource _gradesSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _gradesController =
        Provider.of<CrudController<Grade>>(context, listen: false);
    _gradesController.onUpdated.removeListener(_handleControllerError);
    _gradesController.onUpdated.addListener(_handleControllerError);

    _gradesSource = GradesDataSource(_gradesController,
        Provider.of<CrudController<Course>>(context, listen: false));
  }

  @override
  void dispose() {
    _gradesController.onUpdated.removeListener(_handleControllerError);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(title: 'GPAs'),
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataGridPage(
                controller: _gridController,
                dataSource: _gradesSource,
                showCheckboxColumn: true,
                columns: GPAColumns.values
                    .map((e) => buildGridColumn(
                          context,
                          e.name,
                          visible: e != GPAColumns.code,
                        ))
                    .toList(),
                onPressDelete: () {
                  String? code = _gridController.selectedRow
                      ?.getCells()
                      .firstOrNull
                      ?.value;

                  if (code != null) {
                    _gradesController.removeByKey(code);
                  }
                },
                onPressAdd: () => showDialog(
                  context: context,
                  builder: (_) => const Dialog(child: AddGradeForm()),
                ),
                buildSearchFilters: (searchText) => {
                  GPAColumns.course.name: FilterCondition(
                    type: FilterType.contains,
                    value: searchText,
                    filterBehavior: FilterBehavior.stringDataType,
                    filterOperator: FilterOperator.or,
                  ),
                  GPAColumns.grade.name: FilterCondition(
                    type: FilterType.contains,
                    value: searchText,
                    filterBehavior: FilterBehavior.stringDataType,
                    filterOperator: FilterOperator.or,
                  ),
                },
              ),
              const GPAGauge(),
            ],
          ),
        ),
      ],
    );
  }

  void _handleControllerError(Grade? oldObj, Response<Grade> newValue) {
    if (newValue.errorStr.isNotEmpty) {
      final SnackBar alert = alertSnackBar(
        context,
        newValue.errorStr,
        AlertTypes.error,
      );

      ScaffoldMessenger.of(context).showSnackBar(alert);
    }
  }
}
