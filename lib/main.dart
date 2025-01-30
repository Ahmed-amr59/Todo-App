import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_lecture/HomeScreen.dart';
import 'package:sqflite_lecture/Shared/bloc_observer.dart';

void main(  ){
  Bloc.observer=MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:Homescreen(),
    );
  }
}