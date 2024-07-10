import 'package:flutter/material.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
import 'package:link/screens/forms/add_form.dart';
import 'package:link/validators/not_empty_validator.dart';
import 'package:provider/provider.dart';

class AddLocationForm extends StatefulWidget {
  const AddLocationForm({super.key});

  @override
  State<AddLocationForm> createState() => _AddLocationFormState();
}

class _AddLocationFormState extends State<AddLocationForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final locController = Provider.of<CrudController<Location>>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PageHeader(title: 'Add Location'),
          AddForm.crud(
            formKey: _formKey,
            crudController: locController,
            dtoBuilder: () => LocationDTO(
              name: _nameController.text,
              description: _descriptionController.text,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedTextFieldForm(
                  controller: _nameController,
                  labelText: 'Name',
                  maxLines: 1,
                  validator: (value) =>
                      NotEmptyValidator('Name').validate(value),
                ),
                const SizedBox(height: 8.0),
                OutlinedTextFieldForm(
                  controller: _descriptionController,
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
