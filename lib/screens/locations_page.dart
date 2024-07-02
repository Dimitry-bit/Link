import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/locations_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/location_data_source.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
import 'package:link/screens/add_location_form.dart';
import 'package:link/screens/data_grid_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _gridController = DataGridController();

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
      Response<Location> res = controller.update(name, dto);

      if (res.errorStr.isNotEmpty) {
        final SnackBar alert = alertSnackBar(
          context,
          res.errorStr,
          AlertTypes.error,
        );

        ScaffoldMessenger.of(context).showSnackBar(alert);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locController = Provider.of<LocationsController>(context);
    final locationsSource = LocationDataSource(
      locations: locController.getAll(),
      onCellEdit: (rowIndex, columnName, newValue) {
        _handleCellEdit(locController, rowIndex, columnName, newValue);
      },
    );

    return Column(
      children: [
        const PageHeader(title: 'Locations'),
        DataGridPage(
          controller: _gridController,
          dataSource: locationsSource,
          columnNames: LocationColumns.values.map((e) => e.name).toList(),
          onPressDelete: () {
            String? name =
                _gridController.selectedRow?.getCells().firstOrNull?.value;

            if (name != null) {
              locController.removeByName(name);
            }
          },
          onPressAdd: () => showDialog(
            context: context,
            builder: (_) => const Dialog(child: AddLocationForm()),
          ),
          buildSearchFilters: (searchText) => {
            LocationColumns.name.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
            ),
          },
        )
      ],
    );
  }
}
