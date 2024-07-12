import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/material_data_grid_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/data_grid_source_base.dart';
import 'package:link/models/repository_model.dart';
import 'package:link/utils/string_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

GridColumn buildGridColumn(
  BuildContext context,
  String columnName, {
  TextStyle? style,
  bool visible = true,
  bool allowEdition = true,
  bool allowSorting = true,
  bool allowFiltering = true,
}) {
  return GridColumn(
    columnName: columnName,
    visible: visible,
    allowEditing: allowEdition,
    allowSorting: allowSorting,
    allowFiltering: allowFiltering,
    label: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        StringUtils.toTitleCase(columnName),
        overflow: TextOverflow.clip,
        style: style ??
            Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class CrudDataGrid<T extends RepositoryModel<T>> extends StatefulWidget {
  final DataGridController controller;
  final DataGridSourceBase dataSource;
  final CrudController<T> crudController;
  final String keyColumnName;
  final List<GridColumn> columns;
  final Widget addForm;
  final Map<String, FilterCondition> Function(String)? buildSearchFilters;
  final bool showCheckboxColumn;
  final double pagerHeight;

  const CrudDataGrid({
    required this.controller,
    required this.dataSource,
    required this.crudController,
    required this.columns,
    required this.keyColumnName,
    required this.addForm,
    this.buildSearchFilters,
    this.showCheckboxColumn = false,
    this.pagerHeight = 50,
    super.key,
  });

  @override
  State<CrudDataGrid> createState() => _CrudDataGridState();
}

class _CrudDataGridState extends State<CrudDataGrid> {
  final _searchController = TextEditingController();
  int _rowsPerPage = 25;

  @override
  void initState() {
    super.initState();
    widget.crudController.onUpdated.addListener(_handleUpdateError);
  }

  @override
  void dispose() {
    widget.crudController.onUpdated.removeListener(_handleUpdateError);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialDataGridHeader(
                searchController: _searchController,
                onSearchChanged: _handleOnSearchChanged,
                onPressFirst: _defaultRemove,
                onPressSecond: _defaultAdd,
              ),
              const SizedBox(height: 8.0),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Column(
                      children: [
                        _buildDataGrid(constraint),
                        _buildDataGridPager(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
    final double height = constraint.maxHeight -
        ((widget.dataSource.rowsPerPage != null) ? widget.pagerHeight : 0);

    return SizedBox(
      height: height,
      width: constraint.maxWidth,
      child: SfDataGrid(
        controller: widget.controller,
        source: widget.dataSource,
        rowsPerPage: _rowsPerPage,
        allowEditing: true,
        allowSorting: true,
        showCheckboxColumn: widget.showCheckboxColumn,
        checkboxColumnSettings: const DataGridCheckboxColumnSettings(
          showCheckboxOnHeader: false,
        ),
        columnWidthMode: ColumnWidthMode.fill,
        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
        navigationMode: GridNavigationMode.cell,
        selectionMode: SelectionMode.single,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        headerGridLinesVisibility: GridLinesVisibility.horizontal,
        columns: widget.columns,
      ),
    );
  }

  Widget _buildDataGridPager() {
    double pageCount =
        (widget.crudController.getAll().length / _rowsPerPage).ceilToDouble();

    return (widget.dataSource.rowsPerPage != null)
        ? SizedBox(
            height: widget.pagerHeight,
            child: SfDataPager(
              itemHeight: widget.pagerHeight - 10,
              navigationItemHeight: widget.pagerHeight - 10,
              delegate: widget.dataSource,
              direction: Axis.horizontal,
              availableRowsPerPage: const [25, 10, 20, 50, 100],
              pageCount: pageCount,
              onRowsPerPageChanged: (int? rowsPerPage) {
                setState(() {
                  _rowsPerPage = rowsPerPage!;
                  widget.dataSource.rowsPerPage = _rowsPerPage;
                });
              },
            ),
          )
        : Container();
  }

  void _defaultRemove() {
    String key = widget.controller.selectedRow
        ?.getCells()
        .firstWhere((element) => element.columnName == widget.keyColumnName)
        .value;

    widget.crudController.removeByKey(key);
  }

  void _defaultAdd() {
    showDialog(
      context: context,
      builder: (_) => Dialog(child: widget.addForm),
    );
  }

  void _handleOnSearchChanged(String value) {
    widget.dataSource.clearFilters();
    if (widget.buildSearchFilters != null) {
      Map<String, FilterCondition> filters = widget.buildSearchFilters!(value);
      filters.forEach((key, value) => widget.dataSource.addFilter(key, value));
    }
  }

  void _handleUpdateError(dynamic oldValue, Response<dynamic> newValue) {
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
