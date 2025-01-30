import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_lecture/ArchivedScreen.dart';
import 'package:sqflite_lecture/DoneScreen.dart';
import 'package:sqflite_lecture/Shared/States.dart';
import 'package:sqflite_lecture/Shared/cubit.dart';
import 'package:sqflite_lecture/TasksScreen.dart';

import 'constants.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController timecontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is InsertToDatabase) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.teal,
            title: Text(
              "${cubit.Titles[cubit.Currentindex]}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: cubit.Screens[cubit.Currentindex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            elevation: 10,
            currentIndex: cubit.Currentindex,
            onTap: (Index) {
              setState(() {
                cubit.changeIndex(Index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_sharp), label: 'Task'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline_sharp), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_rounded), label: 'Archived'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      title: titlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text);
                }
              }
              else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      elevation: 20,
                      (context) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                gradient: LinearGradient(
                                    colors: [Colors.white70, Colors.white60],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titlecontroller,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Task Title",
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.task_rounded),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Title can't be Empty";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.none,
                                  controller: timecontroller,
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Task Time",
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon:
                                        const Icon(Icons.watch_later_outlined),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Time can't be Empty";
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      if (value != null) {
                                        timecontroller.text =
                                            value.format(context).toString();
                                      }
                                    });
                                  },
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.none,
                                  controller: datecontroller,
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Task Date",
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon:
                                        const Icon(Icons.calendar_month),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Date can't be Empty";
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2030-05-09"))
                                        .then((value) {
                                      if (value != null) {
                                        datecontroller.text = DateFormat()
                                            .add_yMMMd()
                                            .format(value);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  cubit.changebottomsheetstate(
                      isShown: false, icon: Icons.edit);
                });
                cubit.changebottomsheetstate(isShown: true, icon: Icons.add);
              }
            },
            child: Icon(
              cubit.triggerdIcon,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
