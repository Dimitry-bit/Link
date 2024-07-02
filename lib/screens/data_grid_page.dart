import 'package:flutter/material.dart';
import 'package:link/components/material_data_grid.dart';
import 'package:link/components/material_data_grid_header.dart';
import 'package:link/utils/string_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataGridPage extends StatefulWidget {
  final DataGridController controller;
  final DataGridSource dataSource;
  final void Function() onPressDelete;
  final void Function() onPressAdd;
  final List<String> columnNames;
  final Map<String, FilterCondition> Function(String)? buildSearchFilters;

  const DataGridPage({
    required this.controller,
    required this.dataSource,
    required this.columnNames,
    required this.onPressDelete,
    required this.onPressAdd,
    this.buildSearchFilters,
    super.key,
  });

  @override
  State<DataGridPage> createState() => _DataGridPageState();
}

class _DataGridPageState extends State<DataGridPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableHeaderStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

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
                  columns: widget.columnNames
                      .map((e) => GridColumn(
                            columnName: e,
                            label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                StringUtils.toTitleCase(e),
                                overflow: TextOverflow.clip,
                                style: tableHeaderStyle,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
