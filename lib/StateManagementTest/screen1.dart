import 'package:flutter/material.dart';
import 'package:sqflite_lecture/StateManagementTest/StateTest.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${
          MyInheritedWidget.get(context).name??"null"
          }"),
          Text("This is Screen 1"),
          TextFormField(
            onEditingComplete:(){

            } ,
          ),
        ],
      ),),
    );
  }
}
