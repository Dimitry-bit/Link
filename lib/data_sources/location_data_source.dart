import 'package:flutter/material.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/data_grid_source_base.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum LocationColumns {
  name,
  description,
}

class LocationDataSource extends DataGridSourceBase<Location> {
  dynamic _newCellValue;

  LocationDataSource(super.controller);

  @override
  DataGridRow buildDataGridRow(Location v) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: LocationColumns.name.name,
          value: v.name,
        ),
        DataGridCell<String>(
          columnName: LocationColumns.description.name,
          value: v.description,
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
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
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

    LocationDTO dto = LocationDTO();
    if (column.columnName == LocationColumns.name.name) {
      dto.name = _newCellValue.toString();
    } else if (column.columnName == LocationColumns.description.name) {
      dto.description = _newCellValue.toString();
    }

    final int dataRowIndex = rows.indexOf(dataGridRow);
    String? name = dataGridRow.getCells().first.value;
    if (name != null) {
      Response<Location> res = controller.update(name, dto);

      if (!res.error()) {
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
