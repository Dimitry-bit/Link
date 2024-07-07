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
