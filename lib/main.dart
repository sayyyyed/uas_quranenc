// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uas_quranenc/quran.dart';
import 'package:uas_quranenc/start.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      routes: {
        '/quran': (context) => QuranApp(),
      },
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Start(),
      debugShowCheckedModeBanner: false,
    );
  }
}
