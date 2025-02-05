import 'package:flutter/material.dart';
import 'package:sqflite_lecture/StateManagementTest/screen1.dart';
import 'package:sqflite_lecture/StateManagementTest/screen2.dart';

class Statetest extends StatefulWidget {
  const Statetest({super.key});

  @override
  State<Statetest> createState() => _StatetestState();
}

class _StatetestState extends State<Statetest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${MyInheritedWidget.get(context).name??"null"}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Screen1()),
                        );
                      },
                      child: Text("Screen 1")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Screen2()),
                        );
                      },
                      child: Text("Screen 2")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final String? name;

  MyInheritedWidget({required super.child, this.name});

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    return oldWidget.name == name;
  }

  static MyInheritedWidget get(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!;
}
