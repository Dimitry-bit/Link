import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/components/rectangle_elevated_button.dart';
import 'package:link/controllers/locations_controller.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
import 'package:link/screens/add_location_form.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _searchController = TextEditingController();
  final _dataGridController = DataGridController();
  LocationsDataSource? _locationsDataSource;

  Widget _buildTableHeader(LocationsController controller) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          height: 55,
          child: OutlinedTextFieldForm(
            controller: _searchController,
            labelText: 'Search',
            hintText: 'Name',
            maxLines: 1,
            onChanged: (text) {
              _locationsDataSource?.clearFilters();
              _locationsDataSource?.addFilter(
                'name',
                FilterCondition(
                  type: FilterType.contains,
                  value: text,
                  filterBehavior: FilterBehavior.stringDataType,
                ),
              );
            },
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        SizedBox(
          width: 85,
          height: 35,
          child: OutlinedTextButton(
            text: 'DELETE',
            color: Colors.red,
            onPressed: () {
              String? name = _dataGridController.selectedRow
                  ?.getCells()
                  .firstOrNull
                  ?.value;

              if (name != null) {
                controller.removeLocationById(name);
              }
            },
          ),
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 85,
          height: 35,
          child: RectangleElevatedButton(
            text: 'Add',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const Dialog(child: AddLocationForm()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, LocationsController controller) {
    final theme = Theme.of(context);
    final tableHeaderStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    _locationsDataSource = LocationsDataSource(
      locations: controller.getAll(),
      controller: controller,
    );

    return SfDataGrid(
      controller: _dataGridController,
      source: _locationsDataSource!,
      allowEditing: true,
      allowSorting: true,
      shrinkWrapRows: true,
      columnWidthMode: ColumnWidthMode.fill,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      gridLinesVisibility: GridLinesVisibility.horizontal,
      headerGridLinesVisibility: GridLinesVisibility.horizontal,
      columns: [
        GridColumn(
          columnName: 'name',
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Name',
              overflow: TextOverflow.clip,
              style: tableHeaderStyle,
            ),
          ),
        ),
        GridColumn(
          columnName: 'description',
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              overflow: TextOverflow.clip,
              style: tableHeaderStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final locController = Provider.of<LocationsController>(context);

    return Column(
      children: [
        const PageHeader(title: 'Locations'),
        Flexible(
          fit: FlexFit.loose,
          child: Card(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTableHeader(locController),
                  const SizedBox(height: 8.0),
                  Flexible(child: _buildTable(context, locController)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LocationsDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  LocationsController controller;

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  LocationsDataSource({
    required List<Location> locations,
    required this.controller,
  }) {
    dataGridRows = locations
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'name',
                value: e.name,
              ),
              DataGridCell<String>(
                columnName: 'description',
                value: e.description,
              ),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    String currentName = dataGridRows[dataRowIndex].getCells()[0].value;

    LocationDTO dto = LocationDTO();
    if (column.columnName == 'name') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'name', value: newCellValue);
      dto.name = newCellValue.toString();
      Location l = controller.getByName(currentName)!;
      controller.update(l, dto);
    } else if (column.columnName == 'description') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'description', value: newCellValue);
      dto.description = newCellValue.toString();
      Location l = controller.getByName(currentName)!;
      controller.update(l, dto);
    }
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
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (String value) {
          newCellValue = value.isNotEmpty ? value : null;
        },
      ),
    );
  }
}
