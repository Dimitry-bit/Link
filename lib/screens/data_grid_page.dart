import 'package:flutter/material.dart';
import 'package:link/components/material_data_grid.dart';
import 'package:link/components/material_data_grid_header.dart';
import 'package:link/utils/string_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

GridColumn buildGridColumn(BuildContext context, String columnName,
    {TextStyle? style,
    bool visible = true,
    bool allowEdition = true,
    bool allowSorting = true,
    bool allowFiltering = true}) {
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

class DataGridPage extends StatefulWidget {
  final DataGridController controller;
  final DataGridSource dataSource;
  final void Function() onPressDelete;
  final void Function() onPressAdd;
  final List<GridColumn> columns;
  final Map<String, FilterCondition> Function(String)? buildSearchFilters;
  final bool showCheckboxColumn;

  const DataGridPage({
    required this.controller,
    required this.dataSource,
    required this.columns,
    required this.onPressDelete,
    required this.onPressAdd,
    this.buildSearchFilters,
    this.showCheckboxColumn = false,
    super.key,
  });

  @override
  State<DataGridPage> createState() => _DataGridPageState();
}

class _DataGridPageState extends State<DataGridPage> {
  final _searchController = TextEditingController();

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
                onPressFirst: widget.onPressDelete,
                onPressSecond: widget.onPressAdd,
              ),
              const SizedBox(height: 8.0),
              Flexible(
                child: MaterialDataGrid(
                  dataGridController: widget.controller,
                  dataSource: widget.dataSource,
                  columns: widget.columns,
                  showCheckboxColumn: widget.showCheckboxColumn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
