import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/page_header.dart';
import 'package:link/components/rectangle_elevated_button.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/grade_dto.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';
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

  void addGrade(
    CrudController<Grade> gradesController,
    CrudController<Course> coursesController,
  ) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dto = GradeDTO(
      course: coursesController.getByKey(courseKey!),
      gradeType: gradeType,
    );
    final Response<Grade> res = gradesController.create(dto);
    final SnackBar alert = alertSnackBar(
      context,
      res.errorStr.isEmpty ? "Added grade." : res.errorStr,
      res.errorStr.isEmpty ? AlertTypes.success : AlertTypes.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(alert);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final coursesController = Provider.of<CrudController<Course>>(context);
    final gradesController = Provider.of<CrudController<Grade>>(context);

    courseKey ??= coursesController.getAll().firstOrNull?.code;
    gradeType ??= GradeTypes.A_PLUS;

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const PageHeader(title: 'Add Grade'),
            DropdownButtonFormField<String>(
              value: courseKey,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Choose a course'),
              items: coursesController
                  .getAll()
                  .map((e) => DropdownMenuItem(
                      value: e.primaryKey(), child: Text(e.name)))
                  .toList(),
              onChanged: (value) => setState(() => courseKey = value),
              validator: (value) =>
                  (value == null) ? 'Course is missing' : null,
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<GradeTypes>(
              value: gradeType,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Choose a grade'),
              items: GradeTypes.values.map((e) {
                return DropdownMenuItem(
                    value: e, child: Text(Grade.gradeToLetter(e)));
              }).toList(),
              onChanged: (value) => setState(() => gradeType = value),
              validator: (value) => (value == null) ? 'Grade is missing' : null,
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
                  onPressed: () =>
                      addGrade(gradesController, coursesController),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
