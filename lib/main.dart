import 'package:flutter/material.dart';
import 'package:link/controllers/locations_controller.dart';
import 'package:link/models/location.dart';
import 'package:link/models/user_settings.dart';
import 'package:link/repositories/application_repository.dart';
import 'package:provider/provider.dart';
import 'package:link/screens/home_page.dart';

void main() {
  ApplicationRepository appRepo = ApplicationRepository();
  for (int i = 0; i < 10; i++) {
    Location location = Location('Test Location $i', 'Test Description $i');
    appRepo.locations.add(location);
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserSettings>(create: (_) => UserSettings()),
      ChangeNotifierProvider<LocationsController>(
          create: (_) => LocationsController(appRepo.locations)),
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
