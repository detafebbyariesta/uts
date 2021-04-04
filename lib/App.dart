import 'package:flutter/material.dart';
import 'package:uts/model/homeKopsis.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambah Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeKopsis(),
    );
  }
}