import 'package:flutter/material.dart';

void main() => runApp(const FlutterLab());

class FlutterLab extends StatefulWidget {
  const FlutterLab({super.key});

  @override
  State<FlutterLab> createState() => _FlutterLabState();
}

class _FlutterLabState extends State<FlutterLab> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Flutter Lab 🧪'),
        ),
        body: Center(
          child: Text(
            'Welcome to the laboratory of Flutter!! ⚗️🔬',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
