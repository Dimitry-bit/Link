import 'package:flutter/material.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/models/repository_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class DataGridSourceBase<T extends RepositoryModel<T>>
    extends DataGridSource {
  @protected
  final CrudController<T> controller;

  late List<DataGridRow> _dataGridRows;

  DataGridSourceBase(this.controller) {
    _dataGridRows = controller.getAll().map((e) {
      return buildDataGridRow(e);
    }).toList();

    controller.onCreated.addListener(_handleOnCreate);
    controller.onRemoved.addListener(_handleOnDelete);
  }

  @override
  void dispose() {
    controller.onCreated.removeListener(_handleOnCreate);
    controller.onRemoved.removeListener(_handleOnDelete);

    super.dispose();
  }

  @protected
  DataGridRow buildDataGridRow(T v);

  @override
  List<DataGridRow> get rows => _dataGridRows;

  /// Submit a cell for edition, bypassing [buildEditWidget].
  ///
  /// This method is intended to handle cell edits in a data grid without triggering
  /// the standard edit widget build process. It initiates the cell edit process,
  /// and notifies listeners accordingly.
  ///
  /// It uses a "hack" by creating a fake [GridColumn] to simulate the column properties
  /// necessary for editing operations.
  @protected
  void directCellEdit(DataGridRow row, DataGridCell cell) {
    final cellIndex = RowColumnIndex(
      rows.indexOf(row),
      row.getCells().indexOf(cell),
    );

    // THIS IS A HACK!
    // Caller should not depend on GridColumn's attributes expect columnName
    final fakeColumn = GridColumn(
      columnName: cell.columnName,
      label: const Text(''),
    );

    if (onCellBeginEdit(row, cellIndex, fakeColumn)) {
      onCellSubmit(row, cellIndex, fakeColumn);

      // Rebuild DataGridRowAdapter for the current cell or row
      if (rows.contains(row)) {
        notifyDataSourceListeners(rowColumnIndex: cellIndex);
      } else {
        notifyListeners();
      }
    }
  }

  void _handleOnCreate(Response<T> res) {
    if (res.errorStr.isNotEmpty || res.data == null) {
      return;
    }

    _dataGridRows.add(buildDataGridRow(res.data!));
    notifyDataSourceListeners();
  }

  void _handleOnDelete(T v) {
    _dataGridRows.removeWhere((r) {
      return r.getCells().any((c) => c.value == v.primaryKey());
    });

    notifyDataSourceListeners();
  }
}
