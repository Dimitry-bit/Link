import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
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
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
