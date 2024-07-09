import 'package:flutter/material.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/grades_controller.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';
import 'package:link/models/location.dart';
import 'package:link/models/person.dart';
import 'package:link/models/user_settings.dart';
import 'package:link/repositories/application_repository.dart';
import 'package:link/repositories/repository.dart';
import 'package:provider/provider.dart';
import 'package:link/screens/home_page.dart';

ApplicationRepository _appRepo = ApplicationRepository();
Repository<Grade> _grades = Repository();

void main() {
  _seed();

  CrudController<Course> coursesController = CrudController(_appRepo.courses);
  coursesController.runtimeType;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserSettings>(create: (_) => UserSettings()),
      ChangeNotifierProvider.value(value: coursesController),
      ChangeNotifierProvider(create: (_) => CrudController(_appRepo.locations)),
      ChangeNotifierProvider(create: (_) => CrudController(_appRepo.personnel)),
      ChangeNotifierProvider<CrudController<Grade>>(create: (_) {
        return GradesController(_grades, coursesController);
      }),
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      title: "Link",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void _seed() {
  for (int i = 0; i < 10; i++) {
    Person person = Person('Test Person $i', 'test$i@example.com', i % 2 == 0);
    _appRepo.personnel.add(person);

    Location location = Location('Test Location $i', 'Test Description $i');
    _appRepo.locations.add(location);

    Course course = Course(
      'Course $i',
      'CS$i',
      'Dept $i',
      i + 1,
      i + 1,
      i % 2 == 0,
      i % 2 != 0,
      i % 2 == 0,
    );
    _appRepo.courses.add(course);
    _grades.add(Grade(GradeTypes.A, course: course));
  }
}
