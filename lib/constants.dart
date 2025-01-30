import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget noTasks() => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu,
            size: 100,
          ),
          Text(
            "There is no Tasks",
            style: TextStyle(color: Colors.grey, fontSize: 30),
          )
        ],
      ),
    );
SnackBar snackbarfunction() =>
    SnackBar(backgroundColor: Colors.deepOrange,
        closeIconColor:Colors.white ,
        showCloseIcon: true,
        content: Text(
      "You have deleted the Task",
      style: TextStyle(color: Colors.white),
    ));
