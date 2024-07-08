import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/location_data_source.dart';
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
  late CrudController<Location> _locController;
  late LocationDataSource _locSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _locController =
        Provider.of<CrudController<Location>>(context, listen: false);
    _locController.onUpdated.removeListener(_handleControllerError);
    _locController.onUpdated.addListener(_handleControllerError);

    _locSource = LocationDataSource(_locController);
  }

  @override
  void dispose() {
    _locController.onUpdated.removeListener(_handleControllerError);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Locations'),
        DataGridPage(
          controller: _gridController,
          dataSource: _locSource,
          columns: LocationColumns.values
              .map((e) => buildGridColumn(context, e.name))
              .toList(),
          onPressDelete: () {
            String? name =
                _gridController.selectedRow?.getCells().firstOrNull?.value;

            if (name != null) {
              _locController.removeByKey(name);
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

  void _handleControllerError(Location? oldObj, Response<Location> newValue) {
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
