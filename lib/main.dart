import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'persons_page.dart';
import 'package:flutter_exam/provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PersonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[1200]),
      ),
      home: const PersonsPage(),
    );
  }
}
