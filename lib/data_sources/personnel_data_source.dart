import 'package:flutter/material.dart';
import 'package:link/controllers/persons_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/data_grid_source_base.dart';
import 'package:link/dtos/person_dto.dart';
import 'package:link/models/person.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum PersonnelColumns {
  name,
  email,
}

class PersonnelDataSource extends DataGridSourceBase<Person> {
  dynamic _newCellValue;

  PersonnelDataSource(PersonnelController super.controller);

  @override
  DataGridRow buildDataGridRow(Person v) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: PersonnelColumns.name.name,
          value: (v.isDoctor ? 'Dr ' : 'TA ') + v.name,
        ),
        DataGridCell<String>(
          columnName: PersonnelColumns.email.name,
          value: v.email,
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
                child: Text(
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

    PersonDTO dto = PersonDTO();
    if (column.columnName == PersonnelColumns.name.name) {
      dto.name = _newCellValue.toString();
    } else if (column.columnName == PersonnelColumns.email.name) {
      dto.email = _newCellValue.toString();
    }

    int dataRowIndex = rows.indexOf(dataGridRow);
    String? email = dataGridRow.getCells().elementAtOrNull(1)?.value;
    if (email != null) {
      PersonnelController ctrl = controller as PersonnelController;
      Response<Person> res = ctrl.update(email, dto);

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
    final editingController = TextEditingController();
    final String displayText =
        dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString();

    _newCellValue = null;

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
        onChanged: (text) => _newCellValue = text,
      ),
    );
  }
}
