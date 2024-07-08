import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/models/grade.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GPAGauge extends StatelessWidget {
  const GPAGauge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metricsStyle = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );

    final grades = Provider.of<CrudController<Grade>>(context).getAll();
    final gradesMap = SplayTreeMap<String, int>();
    final cumulativeGPA = Grade.cumulativeGPA(grades);

    for (var grade in grades) {
      gradesMap.update(
        Grade.gradeToLetter(grade.type).characters.first,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return SizedBox(
      width: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const PageHeader(title: 'CGPA'),
              SfRadialGauge(
                enableLoadingAnimation: true,
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 4.0,
                    showFirstLabel: true,
                    showLastLabel: true,
                    showTicks: false,
                    pointers: [
                      RangePointer(
                        value: cumulativeGPA,
                        width: 0.1,
                        cornerStyle: CornerStyle.bothCurve,
                        sizeUnit: GaugeSizeUnit.factor,
                        enableAnimation: true,
                        color: Color.lerp(
                          Colors.redAccent,
                          Colors.greenAccent,
                          cumulativeGPA / 4.0,
                        ),
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          cumulativeGPA.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Courses', style: metricsStyle),
                      Text(grades.length.toString(), style: metricsStyle),
                    ],
                  ),
                  ...gradesMap.entries.map((e) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${e.key}'s", style: metricsStyle),
                        Text(e.value.toString(), style: metricsStyle),
                      ],
                    );
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
