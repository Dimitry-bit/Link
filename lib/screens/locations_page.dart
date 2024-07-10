import 'package:flutter/material.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/data_sources/location_data_source.dart';
import 'package:link/models/location.dart';
import 'package:link/screens/forms/add_location_form.dart';
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

    _locController = Provider.of<CrudController<Location>>(context, listen: false);
    _locSource = LocationDataSource(_locController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Locations'),
        DataGridPage<Location>(
          controller: _gridController,
          dataSource: _locSource,
          crudController: _locController,
          addForm: const AddLocationForm(),
          keyColumnName: LocationColumns.name.name,
          columns: LocationColumns.values
              .map((e) => buildGridColumn(context, e.name))
              .toList(),
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
