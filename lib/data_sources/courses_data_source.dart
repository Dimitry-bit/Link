import 'package:flutter/material.dart';
import 'package:link/controllers/courses_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/data_grid_source_base.dart';
import 'package:link/dtos/course_dto.dart';
import 'package:link/models/course.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum CourseColumns {
  code,
  name,
  department,
  creditHours,
  year,
  hasLecture,
  hasLab,
  hasSection,
}

class CoursesDataSource extends DataGridSourceBase<Course> {
  dynamic _newCellValue;

  CoursesDataSource(CoursesController super.controller);

  @override
  DataGridRow buildDataGridRow(Course v) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: CourseColumns.code.name,
          value: v.code,
        ),
        DataGridCell<String>(
          columnName: CourseColumns.name.name,
          value: v.name,
        ),
        DataGridCell<String>(
          columnName: CourseColumns.department.name,
          value: v.department,
        ),
        DataGridCell<int>(
          columnName: CourseColumns.creditHours.name,
          value: v.creditHours,
        ),
        DataGridCell<int>(
          columnName: CourseColumns.year.name,
          value: v.year,
        ),
        DataGridCell<bool>(
          columnName: CourseColumns.hasLecture.name,
          value: v.hasLecture,
        ),
        DataGridCell<bool>(
          columnName: CourseColumns.hasLab.name,
          value: v.hasLab,
        ),
        DataGridCell<bool>(
          columnName: CourseColumns.hasSection.name,
          value: v.hasSection,
        ),
      ],
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: () {
              if ((cell.columnName == CourseColumns.hasLecture.name) ||
                  (cell.columnName == CourseColumns.hasLab.name) ||
                  (cell.columnName == CourseColumns.hasSection.name)) {
                return Checkbox(
                  value: cell.value,
                  onChanged: (value) {
                    final cellIndex = RowColumnIndex(
                      rows.indexOf(row),
                      row.getCells().indexOf(cell),
                    );

                    final fakeColumn = GridColumn(
                      columnName: cell.columnName,
                      label: const Text(''),
                    );

                    _newCellValue = value;
                    onCellSubmit(row, cellIndex, fakeColumn);
                    _newCellValue = null;
                  },
                );
              } else {
                return Text(
                  cell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                );
              }
            }());
      }).toList(),
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

    CourseDTO dto = CourseDTO();
    if (column.columnName == CourseColumns.code.name) {
      dto.code = _newCellValue.toString();
    } else if (column.columnName == CourseColumns.name.name) {
      dto.name = _newCellValue.toString();
    } else if (column.columnName == CourseColumns.department.name) {
      dto.department = _newCellValue.toString();
    } else if (column.columnName == CourseColumns.creditHours.name) {
      dto.creditHours = _newCellValue;
    } else if (column.columnName == CourseColumns.year.name) {
      dto.year = _newCellValue;
    } else if (column.columnName == CourseColumns.hasLecture.name) {
      dto.hasLecture = _newCellValue;
    } else if (column.columnName == CourseColumns.hasLab.name) {
      dto.hasLab = _newCellValue;
    } else if (column.columnName == CourseColumns.hasSection.name) {
      dto.hasSection = _newCellValue;
    }

    final int dataRowIndex = rows.indexOf(dataGridRow);
    String? code = dataGridRow.getCells().first.value;

    if (code != null) {
      CoursesController ctrl = controller as CoursesController;
      Response<Course> res = ctrl.update(code, dto);

      if (res.errorStr.isEmpty) {
        rows[dataRowIndex] = buildDataGridRow(res.data!);
      }
    }
  }

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    _newCellValue = null;

    // Disable edit mode for checkbox widgets (Handled by onChange() instead)
    if ((column.columnName == CourseColumns.hasLecture.name) ||
        (column.columnName == CourseColumns.hasLab.name) ||
        (column.columnName == CourseColumns.hasSection.name)) {
      return null;
    }

    final editingController = TextEditingController();
    final String displayText =
        dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString();

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) {
          if ((column.columnName == CourseColumns.creditHours.name) ||
              (column.columnName == CourseColumns.year.name)) {
            int? n = int.tryParse(text);

            if (n != null) {
              _newCellValue = n;
            }
          } else {
            _newCellValue = text;
          }
        },
      ),
    );
  }
}
