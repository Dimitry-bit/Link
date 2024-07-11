import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/material_data_grid.dart';
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

class DataGridPage<T extends RepositoryModel<T>> extends StatefulWidget {
  final DataGridController controller;
  final DataGridSourceBase dataSource;
  final CrudController<T>? crudController;
  final void Function()? onPressDelete;
  final void Function()? onPressAdd;
  final Widget? addForm;
  final List<GridColumn> columns;
  final String keyColumnName;
  final Map<String, FilterCondition> Function(String)? buildSearchFilters;
  final bool showCheckboxColumn;
  final double pagerHeight;

  const DataGridPage({
    required this.controller,
    required this.dataSource,
    this.crudController,
    required this.columns,
    required this.keyColumnName,
    this.onPressDelete,
    this.onPressAdd,
    this.addForm,
    this.buildSearchFilters,
    this.showCheckboxColumn = false,
    this.pagerHeight = 50,
    super.key,
  });

  @override
  State<DataGridPage> createState() => _DataGridPageState();
}

class _DataGridPageState extends State<DataGridPage> {
  final _searchController = TextEditingController();
  int _rowsPerPage = 25;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.crudController?.onUpdated.removeListener(_handleUpdateError);
    widget.crudController?.onUpdated.addListener(_handleUpdateError);
  }

  @override
  void dispose() {
    widget.crudController?.onUpdated.removeListener(_handleUpdateError);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialDataGridHeader(
                searchController: _searchController,
                onSearchChanged: (text) {
                  widget.dataSource.clearFilters();
                  if (widget.buildSearchFilters != null) {
                    Map<String, FilterCondition> filters =
                        widget.buildSearchFilters!(text);

                    for (var e in filters.entries) {
                      widget.dataSource.addFilter(e.key, e.value);
                    }
                  }
                },
                onPressFirst: widget.onPressDelete ?? _defaultRemove,
                onPressSecond: widget.onPressAdd ?? _defaultAdd,
              ),
              const SizedBox(height: 8.0),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Column(
                      children: [
                        SizedBox(
                          height: constraint.maxHeight -
                              ((widget.dataSource.rowsPerPage != null)
                                  ? widget.pagerHeight
                                  : 0),
                          width: constraint.maxWidth,
                          child: MaterialDataGrid(
                            dataGridController: widget.controller,
                            dataSource: widget.dataSource,
                            columns: widget.columns,
                            showCheckboxColumn: widget.showCheckboxColumn,
                          ),
                        ),
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

  Widget _buildDataGridPager() {
    double pageCount =
        (widget.crudController!.getAll().length / _rowsPerPage).ceilToDouble();

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
    if (widget.crudController != null) {
      String key = widget.controller.selectedRow
          ?.getCells()
          .firstWhere((element) => element.columnName == widget.keyColumnName)
          .value;

      widget.crudController?.removeByKey(key);
    }
  }

  void _defaultAdd() {
    if (widget.addForm != null) {
      showDialog(
        context: context,
        builder: (_) => Dialog(child: widget.addForm),
      );
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
