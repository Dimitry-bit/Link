import 'package:flutter/material.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/models/course.dart';
import 'package:link/models/location.dart';
import 'package:link/models/person.dart';
import 'package:link/models/user_settings.dart';
import 'package:link/repositories/application_repository.dart';
import 'package:provider/provider.dart';
import 'package:link/screens/home_page.dart';

void main() {
  ApplicationRepository appRepo = ApplicationRepository();

  for (int i = 0; i < 10; i++) {
    Person person = Person('Test Person $i', 'test$i@example.com', i % 2 == 0);
    appRepo.personnel.add(person);

    Location location = Location('Test Location $i', 'Test Description $i');
    appRepo.locations.add(location);

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
    appRepo.courses.add(course);
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserSettings>(create: (_) => UserSettings()),
      ChangeNotifierProvider(create: (_) => CrudController(appRepo.locations)),
      ChangeNotifierProvider(create: (_) => CrudController(appRepo.personnel)),
      ChangeNotifierProvider(create: (_) => CrudController(appRepo.courses)),
    ],
    child: const MainApp(),
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
