import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:link/models/location.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum LocationColumns {
  name,
  description,
}

class LocationDataSource extends DataGridSource {
  final void Function(
    int rowIndex,
    String columnName,
    dynamic newValue,
  )? onCellEdit;
  final TextEditingController _editingController = TextEditingController();
  List<DataGridRow> _dataGridRows = [];
  dynamic _newCellValue;

  LocationDataSource({required List<Location> locations, this.onCellEdit}) {
    _dataGridRows = locations
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: LocationColumns.name.name,
                value: e.name,
              ),
              DataGridCell<String>(
                columnName: LocationColumns.description.name,
                value: e.description,
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>(
            (cell) => Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                cell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    if (onCellEdit == null) {
      return;
    }
    final oldValue = dataGridRow
        .getCells()
        .firstWhereOrNull((cell) => cell.columnName == column.columnName)
        ?.value;

    if (_newCellValue == null || oldValue == _newCellValue) {
      return;
    }

    onCellEdit!(rowColumnIndex.rowIndex, column.columnName, _newCellValue);
  }

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((cell) => cell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    _newCellValue = null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: _editingController..text = displayText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) => _newCellValue = text,
      ),
    );
  }
}
