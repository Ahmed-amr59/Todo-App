import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_lecture/Shared/States.dart';

import '../ArchivedScreen.dart';
import '../DoneScreen.dart';
import '../TasksScreen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> Screens = [
    Tasksscreen(),
    Donescreen(),
    Archivedscreen(),
  ];
  List<String> Titles=[
    'New Tasks ',
    'Done Tasks',
    "Archived Tasks"
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int Currentindex = 0;
  bool isBottomSheetShown = false;
  bool isLoading=false;
  IconData triggerdIcon = Icons.edit;
  late Database database;
  void changeIndex(int index) {
    Currentindex = index;
    emit(ChangeBottomNavBarState());
  }

  void createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
      await database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('Table Created');
        emit(CreateDatabase());
      }).catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database)async {
          print('Database Opened');
         getDataFromDatabase(database);
    });
  }

  Future insertToDatabase(
      {required title, required time, required date}) async {
    await database
        .transaction((txn) => txn.rawInsert(
              "INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'New')",
            ))
        .then((value) {
      print('$value Inserted Successfully');
      emit(InsertToDatabase());
      getDataFromDatabase(database);
    }).catchError((error) {
      print('Error when inserting new record ${error.toString()}');
    });
  }

  void getDataFromDatabase(database) {
    isLoading=true;
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    database.rawQuery("SELECT * FROM tasks").then((value) {
      for (var element in value) {
        print("Task Retrieved: $element");
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        }
      }
      isLoading=false;
      emit(GetDataFromDatabase()); // Ensure UI updates
    }).catchError((error) {
      print("Error when getting data: ${error.toString()}");
      isLoading=false;
    });
  }

  void changebottomsheetstate({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    triggerdIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void updateDatabase({required String status, required int id}) async {
    await database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      print("Task Updated: ID=$id, New Status=$status"); // Debugging
      getDataFromDatabase(database); // Refresh the database
      emit(UpdateDatabase());
    });
  }
  Future deleteFromDatabase({required int id}) async {
      await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
      print("Task Deleted: ID=$id"); // Debugging
      getDataFromDatabase(database); // Refresh the database
      emit(DeleteFromDatabase());
    });
  }
}
