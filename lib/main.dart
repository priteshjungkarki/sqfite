import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(Database());
}

class Database extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Database'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
      ),
    );
  }
}
