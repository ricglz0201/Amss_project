import 'package:flutter/material.dart';
import 'package:amss_project/pages/root_page.dart';
import 'package:amss_project/extra/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Root',
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new RootPage(auth: new Auth())
  );
}