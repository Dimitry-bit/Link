import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/components/rectangle_elevated_button.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/location_dto.dart';
import 'package:link/models/location.dart';
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

  void addLocation(CrudController<Location> controller) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dto = LocationDTO(
      name: _nameController.text,
      description: _descriptionController.text,
    );
    final Response<Location> res = controller.create(dto);
    final SnackBar alert = alertSnackBar(
      context,
      res.errorStr.isEmpty ? "Added location '${dto.name}'" : res.errorStr,
      res.errorStr.isEmpty ? AlertTypes.success : AlertTypes.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(alert);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final locController = Provider.of<CrudController<Location>>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PageHeader(title: 'Add Location'),
            OutlinedTextFieldForm(
              controller: _nameController,
              labelText: 'Name',
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is missing';
                }

                return null;
              },
            ),
            const SizedBox(height: 8.0),
            OutlinedTextFieldForm(
              controller: _descriptionController,
              labelText: 'Description',
              alignLabelWithHint: true,
              maxLines: 5,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedTextButton(
                  text: 'Cancel',
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8.0),
                RectangleElevatedButton(
                  text: 'Add',
                  onPressed: () => addLocation(locController),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
