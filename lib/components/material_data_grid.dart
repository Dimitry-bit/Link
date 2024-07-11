import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MaterialDataGrid extends StatelessWidget {
  final DataGridController dataGridController;
  final DataGridSource dataSource;
  final List<GridColumn> columns;
  final bool showCheckboxColumn;
  final int? rowsPerPage;

  const MaterialDataGrid({
    required this.dataGridController,
    required this.dataSource,
    required this.columns,
    this.showCheckboxColumn = false,
    this.rowsPerPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      controller: dataGridController,
      source: dataSource,
      rowsPerPage: rowsPerPage,
      allowEditing: true,
      allowSorting: true,
      showCheckboxColumn: showCheckboxColumn,
      checkboxColumnSettings:
          const DataGridCheckboxColumnSettings(showCheckboxOnHeader: false),
      columnWidthMode: ColumnWidthMode.fill,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      gridLinesVisibility: GridLinesVisibility.horizontal,
      headerGridLinesVisibility: GridLinesVisibility.horizontal,
      columns: columns,
    );
  }
}
