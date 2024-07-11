import 'package:flutter/material.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/data_grid_source_base.dart';
import 'package:link/dtos/grade_dto.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum GPAColumns {
  code,
  course,
  grade,
}

class GradesDataSource extends DataGridSourceBase<Grade> {
  static final List<DropdownMenuItem<GradeTypes>> _gradeMenuItems =
      GradeTypes.values.map((e) {
    return DropdownMenuItem(value: e, child: Text(Grade.gradeToLetter(e)));
  }).toList();

  final CrudController<Course> _coursesController;
  late final List<DropdownMenuItem<String>> _courseMenuItems;
  dynamic _newCellValue;

  GradesDataSource(super.controller, CrudController<Course> coursesController)
      : _coursesController = coursesController {
    _courseMenuItems = _coursesController
        .getAll()
        .map((e) => DropdownMenuItem(value: e.code, child: Text(e.name)))
        .toList();
  }

  @override
  DataGridRow buildDataGridRow(Grade v) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: GPAColumns.code.name,
          value: v.primaryKey(),
        ),
        DataGridCell<String>(
          columnName: GPAColumns.course.name,
          value: v.courseName(),
        ),
        DataGridCell<String>(
          columnName: GPAColumns.grade.name,
          value: Grade.gradeToLetter(v.type),
        ),
      ],
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>((cell) => Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: (cell.columnName == GPAColumns.course.name ||
                        cell.columnName == GPAColumns.grade.name)
                    ? DropdownButton(
                        value: cell.columnName == GPAColumns.course.name
                            ? row.getCells().first.value
                            : Grade.letterToGrade(cell.value.toString()),
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                        items: cell.columnName == GPAColumns.course.name
                            ? _courseMenuItems
                            : _gradeMenuItems,
                        onChanged: (value) {
                          _newCellValue = value;
                          directCellEdit(row, cell);
                          _newCellValue = null;
                        },
                      )
                    : Text(
                        cell.value.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
              ))
          .toList(),
    );
  }

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final dynamic oldValue = dataGridRow.getCells()[rowColumnIndex.columnIndex];
    if ((_newCellValue == null) || (oldValue == _newCellValue)) {
      return;
    }

    GradeDTO dto = GradeDTO();
    if (column.columnName == GPAColumns.course.name) {
      dto.course = _coursesController.getByKey(_newCellValue);
    } else if (column.columnName == GPAColumns.grade.name) {
      dto.gradeType = _newCellValue as GradeTypes;
    }

    String key = dataGridRow.getCells().first.value;
    Response<Grade> res = controller.update(key, dto);
    if (res.errorStr.isEmpty) {
      int dataRowIndex = rows.indexOf(dataGridRow);
      rows[dataRowIndex] = buildDataGridRow(res.data!);
    }
  }
}
