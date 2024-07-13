import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/rectangle_elevated_button.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/dtos/dto_base.dart';
import 'package:link/models/repository_model.dart';

class AddForm<T extends RepositoryModel<T>> extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;
  final CrudController<T>? crudController;
  final void Function()? onSubmit;
  final DTOBase<T> Function()? dtoBuilder;

  const AddForm({
    super.key,
    required this.formKey,
    required this.child,
    required this.onSubmit,
  })  : crudController = null,
        dtoBuilder = null;

  const AddForm.crud({
    super.key,
    required this.formKey,
    required this.child,
    required this.crudController,
    required this.dtoBuilder,
  }) : onSubmit = null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
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
                onPressed: onSubmit ?? () => _defaultAdd(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _defaultAdd(BuildContext context) {
    if ((crudController == null) || (dtoBuilder == null)) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    final DTOBase<T> dto = dtoBuilder!();
    final Response<T> res = crudController!.create(dto);
    final SnackBar alert = alertSnackBar(
      context,
      res.error()
          ? res.errorStr()
          : "Added ${T.toString()} {key: ${res.data!.primaryKey()}}.",
      res.error() ? AlertTypes.error : AlertTypes.success,
    );

    ScaffoldMessenger.of(context).showSnackBar(alert);
    Navigator.pop(context);
  }
}
