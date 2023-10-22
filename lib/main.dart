import 'package:flutter/material.dart';
import 'package:jumnah/screens/webview_example_screen.dart';


void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 2));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jumnah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebviewExampleScreen(url: "https://www.jumnah.com"),
    );
  }
}
