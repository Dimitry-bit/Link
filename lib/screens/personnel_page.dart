import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/persons_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/personnel_data_source.dart';
import 'package:link/dtos/person_dto.dart';
import 'package:link/models/person.dart';
import 'package:link/screens/add_person_form.dart';
import 'package:link/screens/data_grid_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PersonnelPage extends StatefulWidget {
  const PersonnelPage({super.key});

  @override
  State<PersonnelPage> createState() => _PersonnelPageState();
}

class _PersonnelPageState extends State<PersonnelPage> {
  final _gridController = DataGridController();

  _handleCellEdit(
    PersonnelController controller,
    int rowIndex,
    String columnName,
    dynamic newValue,
  ) {
    PersonDTO dto = PersonDTO();
    if (columnName == PersonnelColumns.name.name) {
      dto.name = newValue.toString();
    } else if (columnName == PersonnelColumns.email.name) {
      dto.email = newValue.toString();
    }

    String? email =
        _gridController.selectedRow?.getCells().elementAtOrNull(1)?.value;

    if (email != null) {
      Response<Person> res = controller.update(email, dto);

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
    final personnelController = Provider.of<PersonnelController>(context);
    final personnelSource = PersonnelDataSource(
      personnel: personnelController.getAll(),
      onCellEdit: (rowIndex, columnName, newValue) {
        _handleCellEdit(personnelController, rowIndex, columnName, newValue);
      },
    );

    return Column(
      children: [
        const PageHeader(title: 'Doctors/TAs'),
        DataGridPage(
          controller: _gridController,
          dataSource: personnelSource,
          columnNames: PersonnelColumns.values.map((e) => e.name).toList(),
          onPressDelete: () {
            String? email = _gridController.selectedRow
                ?.getCells()
                .elementAtOrNull(1)
                ?.value;

            if (email != null) {
              personnelController.removeByEmail(email);
            }
          },
          onPressAdd: () => showDialog(
            context: context,
            builder: (_) => const Dialog(child: AddPersonForm()),
          ),
          buildSearchFilters: (searchText) => {
            PersonnelColumns.name.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
              filterOperator: FilterOperator.or,
            ),
            PersonnelColumns.email.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
              filterOperator: FilterOperator.or,
            ),
          },
        ),
      ],
    );
  }
}
