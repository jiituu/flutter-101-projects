import 'package:flutter/material.dart';
import 'package:simple_pong/pong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pong Game'),
        ),
        body: SafeArea(child: Pong()),
      ),
    );
  }
}
