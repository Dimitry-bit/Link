import 'package:flutter/material.dart';
import 'package:link/models/user_settings.dart';
import 'package:provider/provider.dart';
import 'package:link/screens/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => UserSettings(),
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
