import 'package:flutter/material.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/dtos/person_dto.dart';
import 'package:link/models/person.dart';
import 'package:link/screens/crud_add_form.dart';
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

  @override
  Widget build(BuildContext context) {
    final personnelController = Provider.of<CrudController<Person>>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PageHeader(title: 'Add Person'),
          AddForm.crud(
            formKey: _formKey,
            crudController: personnelController,
            dtoBuilder: () => PersonDTO(
              name: _nameController.text,
              email: _emailController.text,
              isDoctor: _isDoctor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
