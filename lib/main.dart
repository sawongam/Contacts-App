import 'package:contacts_app/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // scaffoldBackgroundColor: Colors.black12,
          scaffoldBackgroundColor: Colors.blueGrey[900],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
            ),
            labelMedium: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      home: const JsonHome(),
    );
  }
}
