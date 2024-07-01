import 'package:flutter/material.dart';
import 'package:link/components/material_data_grid.dart';
import 'package:link/components/material_data_grid_header.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/locations_controller.dart';
import 'package:link/data_sources/location_data_source.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/screens/add_location_form.dart';
import 'package:link/utils/string_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _searchController = TextEditingController();
  final _gridController = DataGridController();
  late LocationDataSource _locationsSource;

  _handleCellEdit(
    LocationsController controller,
    int rowIndex,
    String columnName,
    dynamic newValue,
  ) {
    LocationDTO dto = LocationDTO();
    if (columnName == LocationColumns.name.name) {
      dto.name = newValue.toString();
    } else if (columnName == LocationColumns.description.name) {
      dto.description = newValue.toString();
    }

    String? name = _gridController.selectedRow?.getCells().firstOrNull?.value;
    if (name != null) {
      controller.update(name, dto);
    }
  }

  Widget _buildHeader(LocationsController controller) {
    return MaterialDataGridHeader(
      searchController: _searchController,
      onSearchChanged: (text) {
        _locationsSource.clearFilters();
        _locationsSource.addFilter(
          LocationColumns.name.name,
          FilterCondition(
            type: FilterType.contains,
            value: text,
            filterBehavior: FilterBehavior.stringDataType,
          ),
        );
      },
      onPressFirst: () {
        String? name =
            _gridController.selectedRow?.getCells().firstOrNull?.value;

        if (name != null) {
          controller.removeLocationById(name);
        }
      },
      onPressSecond: () => showDialog(
        context: context,
        builder: (_) => const Dialog(child: AddLocationForm()),
      ),
    );
  }

  Widget _buildDataGrid(BuildContext context, LocationsController controller) {
    final theme = Theme.of(context);
    final tableHeaderStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    _locationsSource = LocationDataSource(
      locations: controller.getAll(),
      onCellEdit: (rowIndex, columnName, newValue) {
        _handleCellEdit(controller, rowIndex, columnName, newValue);
      },
    );

    return MaterialDataGrid(
      dataGridController: _gridController,
      dataSource: _locationsSource,
      columns: LocationColumns.values
          .map(
            (e) => GridColumn(
              columnName: e.name,
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  StringUtils.toTitleCase(e.name),
                  overflow: TextOverflow.clip,
                  style: tableHeaderStyle,
                ),
              ),
            ),
          )
          .toList(),
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
                  _buildHeader(locController),
                  const SizedBox(height: 8.0),
                  Flexible(child: _buildDataGrid(context, locController)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
