import 'package:flutter/material.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/dtos/grade_dto.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';
import 'package:link/screens/add_form.dart';
import 'package:link/validators/not_null_validator.dart';
import 'package:provider/provider.dart';

class AddGradeForm extends StatefulWidget {
  const AddGradeForm({super.key});

  @override
  State<AddGradeForm> createState() => _AddGradeFormState();
}

class _AddGradeFormState extends State<AddGradeForm> {
  final _formKey = GlobalKey<FormState>();
  String? courseKey;
  GradeTypes? gradeType;

  @override
  Widget build(BuildContext context) {
    final coursesController = Provider.of<CrudController<Course>>(context);
    final gradesController = Provider.of<CrudController<Grade>>(context);

    courseKey ??= coursesController.getAll().firstOrNull?.code;
    gradeType ??= GradeTypes.A_PLUS;

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PageHeader(title: 'Add Grade'),
          AddForm.crud(
            formKey: _formKey,
            crudController: gradesController,
            dtoBuilder: () => GradeDTO(
              course: coursesController.getByKey(courseKey!),
              gradeType: gradeType,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: courseKey,
                  isExpanded: true,
                  decoration:
                      const InputDecoration(labelText: 'Choose a course'),
                  items: coursesController
                      .getAll()
                      .map((e) => DropdownMenuItem(
                          value: e.primaryKey(), child: Text(e.name)))
                      .toList(),
                  onChanged: (value) => setState(() => courseKey = value),
                  validator: (value) =>
                      NotNullValidator('Course').validate(value),
                ),
                const SizedBox(height: 8.0),
                DropdownButtonFormField<GradeTypes>(
                  value: gradeType,
                  isExpanded: true,
                  decoration:
                      const InputDecoration(labelText: 'Choose a grade'),
                  items: GradeTypes.values.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(Grade.gradeToLetter(e)));
                  }).toList(),
                  onChanged: (value) => setState(() => gradeType = value),
                  validator: (value) =>
                      NotNullValidator('Grade').validate(value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
