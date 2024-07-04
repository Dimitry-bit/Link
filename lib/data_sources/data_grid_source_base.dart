import 'package:flutter/material.dart';
import 'package:link/controllers/controller_base.dart';
import 'package:link/controllers/response.dart';
import 'package:link/models/repository_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class DataGridSourceBase<T extends RepositoryModel>
    extends DataGridSource {
  @protected
  final ControllerBase<T> controller;

  late List<DataGridRow> _dataGridRows;

  DataGridSourceBase(this.controller) {
    _dataGridRows = controller.getAll().map((e) {
      return buildDataGridRow(e);
    }).toList();

    controller.addOnCreteListener(_handleOnCreate);
    controller.addOnRemoveListener(_handleOnDelete);
  }

  @override
  void dispose() {
    controller.removeOnCreteListener(_handleOnCreate);
    controller.removeOnRemoveListener(_handleOnDelete);

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
