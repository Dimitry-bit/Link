import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/components/rectangle_elevated_button.dart';
import 'package:link/controllers/courses_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/course_dto.dart';
import 'package:link/models/course.dart';
import 'package:link/validators/int_validator.dart';
import 'package:link/validators/not_empty_validator.dart';
import 'package:provider/provider.dart';

class AddCourseForm extends StatefulWidget {
  const AddCourseForm({super.key});

  @override
  State<AddCourseForm> createState() => _AddCourseFormState();
}

class _AddCourseFormState extends State<AddCourseForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  final _creditHourController = TextEditingController();
  final _yearController = TextEditingController();
  bool _hasLecture = false;
  bool _hasLab = false;
  bool _hasSection = false;

  void addCourse(CoursesController controller) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dto = CourseDTO(
      code: _codeController.text,
      name: _nameController.text,
      department: _deptController.text,
      creditHours: int.tryParse(_creditHourController.text),
      year: int.tryParse(_yearController.text),
      hasLecture: _hasLecture,
      hasLab: _hasLab,
      hasSection: _hasSection,
    );
    final Response<Course> res = controller.create(dto);
    final SnackBar alert = alertSnackBar(
      context,
      res.errorStr.isEmpty ? "Added course {code: ${dto.code}}" : res.errorStr,
      res.errorStr.isEmpty ? AlertTypes.success : AlertTypes.error,
    );

    ScaffoldMessenger.of(context).showSnackBar(alert);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final personnelController = Provider.of<CoursesController>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 600,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PageHeader(title: 'Add Course'),
            Row(
              children: [
                Expanded(
                  child: OutlinedTextFieldForm(
                    controller: _codeController,
                    labelText: 'Code',
                    maxLines: 1,
                    validator: (value) {
                      String? validation =
                          NotEmptyValidator().validate(value);
                      if (validation != null) {
                        return 'Code $validation';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  flex: 2,
                  child: OutlinedTextFieldForm(
                    controller: _nameController,
                    labelText: 'Name',
                    maxLines: 1,
                    validator: (value) {
                      String? validation =
                          NotEmptyValidator().validate(value);
                      if (validation != null) {
                        return 'Name $validation';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedTextFieldForm(
                    controller: _deptController,
                    labelText: 'Department',
                    maxLines: 1,
                    validator: (value) {
                      String? validation =
                          NotEmptyValidator().validate(value);
                      if (validation != null) {
                        return 'Department $validation';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: OutlinedTextFieldForm(
                    controller: _creditHourController,
                    labelText: 'CreditHours',
                    hintText: '0',
                    maxLines: 1,
                    validator: (value) {
                      String? validation =
                          IntValidator(NotEmptyValidator()).validate(value);
                      if (validation != null) {
                        return 'CreditHours $validation';
                      } else if (int.parse(value!) < 0) {
                        return 'CreditHours must be >= 0';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: OutlinedTextFieldForm(
                    controller: _yearController,
                    labelText: 'Year',
                    hintText: '1',
                    maxLines: 1,
                    validator: (value) {
                      String? validation =
                          IntValidator(NotEmptyValidator()).validate(value);
                      if (validation != null) {
                        return 'Year $validation';
                      } else if (int.parse(value!) <= 0) {
                        return 'Year must be > 0';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    value: _hasLecture,
                    onChanged: (value) => setState(() => _hasLecture = value!),
                    title: const Text('Lecture'),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    value: _hasLab,
                    onChanged: (value) => setState(() => _hasLab = value!),
                    title: const Text('Lab'),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    value: _hasSection,
                    onChanged: (value) => setState(() => _hasSection = value!),
                    title: const Text('Section'),
                  ),
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
                  onPressed: () => addCourse(personnelController),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
