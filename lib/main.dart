import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_lecture/HomeScreen.dart';
import 'package:sqflite_lecture/Shared/bloc_observer.dart';
import 'package:sqflite_lecture/StateManagementTest/StateTest.dart';

void main(  ){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness:Brightness.dark,
    systemNavigationBarColor: Colors.cyan,
  ));
  Bloc.observer=MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:MyInheritedWidget( name: "Ahmed",
          child: Statetest()),
    );
  }
}
