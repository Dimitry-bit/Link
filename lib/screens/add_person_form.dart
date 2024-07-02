import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/components/rectangle_elevated_button.dart';
import 'package:link/controllers/persons_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/person_dto.dart';
import 'package:link/models/person.dart';
import 'package:link/utils/email_utils.dart';
import 'package:provider/provider.dart';

class AddPersonForm extends StatefulWidget {
  const AddPersonForm({super.key});

  @override
  State<AddPersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isDoctor = false;

  void addPerson(PersonnelController controller) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dto = PersonDTO(
      name: _nameController.text,
      email: _emailController.text,
      isDoctor: _isDoctor,
    );
    final Response<Person> res = controller.create(dto);
    final SnackBar alert = alertSnackBar(
      context,
      res.errorStr.isEmpty ? "Added person '${dto.name}'" : res.errorStr,
      res.errorStr.isEmpty ? AlertTypes.success : AlertTypes.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(alert);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final personnelController = Provider.of<PersonnelController>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PageHeader(title: 'Add Person'),
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
              controller: _emailController,
              labelText: 'Email',
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is missing';
                } else if (!EmailUtils.isValidEmail(value)) {
                  return 'Invalid email address';
                }

                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Text("Doctor"),
                const Expanded(child: SizedBox()),
                Switch(
                  value: _isDoctor,
                  onChanged: (value) => setState(() => _isDoctor = value),
                ),
              ],
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
                  onPressed: () => addPerson(personnelController),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
