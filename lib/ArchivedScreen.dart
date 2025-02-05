import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_lecture/Shared/States.dart';
import 'package:sqflite_lecture/Shared/cubit.dart';

import 'constants.dart';

class Archivedscreen extends StatefulWidget {
  const Archivedscreen({super.key});
  @override
  State<Archivedscreen> createState() => _ArchivedscreenState();
}

class _ArchivedscreenState extends State<Archivedscreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
      },
      builder: (context,state){
        var tasks=AppCubit.get(context).archivedTasks;
        return tasks.isEmpty?noTasks(): ListView.separated(
          reverse: true,
            itemBuilder: (context, index) => Dismissible(
              direction:DismissDirection.startToEnd,
              key: Key(tasks[index]['id'].toString()),
              background: Container(child: Center(child: Icon(Icons.delete_rounded,color: Colors.white,)),
                decoration: BoxDecoration(color: Colors.red),),
              onDismissed: (direction){
                AppCubit.get(context).deleteFromDatabase(id: tasks[index]["id"]).then((value){
                  ScaffoldMessenger.of(context).showSnackBar(snackbarfunction());
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 50,
                      child: Text(
                        "${tasks[index]['time']}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "${tasks[index]['title']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${tasks[index]['date']}",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                          AppCubit.get(context).updateDatabase(status: 'done', id:tasks[index]['id']);
                        }, icon:Icon(Icons.check_circle_rounded,color: Colors.green,)),
                        IconButton(onPressed: (){
                          AppCubit.get(context).updateDatabase(status: 'archived', id:tasks[index]['id']);
                        }, icon:Icon(Icons.archive_rounded,color: Colors.black87,)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            separatorBuilder: (context, index) => Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            itemCount:tasks.length);
      },
    );
  }
}
