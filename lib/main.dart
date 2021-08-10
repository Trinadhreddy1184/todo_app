import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/tasklist.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String taskname=" ";
  var tasks;
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  Firebase.initializeApp(),
      builder:(context,snapshot){
        if (snapshot.hasError) {
          return MaterialApp(home: Scaffold(body: Container(child: Center(child: Text("Error occured"),))));
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (BuildContext context) { return TaskList(); },
            child: MaterialApp(
              home: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade400,
                  body: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left:0,top:10,right:0,bottom:20),
                        height: 100,
                        child: Center(
                          child: Text("TO DO App",style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 15,top: 0,right: 10,bottom: 0),
                                  width: 270,
                                  decoration:BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ) ,
                                  child:TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter a new Task name",
                                      hintStyle:  TextStyle(fontSize:20,fontWeight: FontWeight.w400,color: Colors.black ),
                                    ),
                                    onChanged: (value){
                                      taskname=value;
                                    },
                                    textAlign: TextAlign.left,
                                    cursorHeight: 20,
                                    cursorColor: Colors.black,
                                    style: TextStyle(fontSize:20,fontWeight: FontWeight.w400,color: Colors.black ),
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0,bottom: 18),
                                child: Consumer<TaskList>(
                                  builder: (context,TaskData,child){
                                    return IconButton(onPressed: (){
                                      if(taskname.isNotEmpty){
                                        TaskData.addtask(taskname);}
                                    }, icon:Icon(CupertinoIcons.plus_circle_fill,color: Colors.black,size: 50,));
                                  },
                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Consumer<TaskList>(
                          builder: (context,TaskData,child){
                            TaskData.updatetask();
                               return  ListView.builder(
                                  itemCount: TaskData.taskcount(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 25.0,right: 25,bottom: 20),
                                      child: Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(onPressed: (){
                                                TaskData.checktask((TaskData.tasks.keys.elementAt(index)), !(TaskData.tasks.values.elementAt(index)));
                                              }, icon:Icon((TaskData.tasks.values.elementAt(index))?CupertinoIcons.checkmark_circle_fill:CupertinoIcons.checkmark_circle,size: 30,color: Colors.black,)),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(TaskData.tasks.keys.elementAt(index),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.black,decoration:(TaskData.tasks.values.elementAt(index))?TextDecoration.lineThrough:null),)),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [IconButton(onPressed: (){
                                                        showDialog(context: context, builder:(BuildContext context){
                                                          return AlertDialog(
                                                            title: Text("Enter a new name"),
                                                            content: TextField(
                                                              decoration: InputDecoration(
                                                                hintText: "Enter a new Task name",
                                                                hintStyle:  TextStyle(fontSize:20,fontWeight: FontWeight.w400,color: Colors.black ),
                                                              ),
                                                              onChanged: (value){
                                                                taskname=value;
                                                              },
                                                              textAlign: TextAlign.left,
                                                              cursorHeight: 20,
                                                              cursorColor: Colors.black,
                                                              style: TextStyle(fontSize:20,fontWeight: FontWeight.w400,color: Colors.black ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  TaskData.renamekey(index,taskname);
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text("Rename"),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                        //
                                                      }, icon:Icon(Icons.edit_outlined,size: 30,color: Colors.black,)),
                                                        IconButton(onPressed:(){
                                                          TaskData.deletetask(TaskData.tasks.keys.elementAt(index));
                                                        }, icon:Icon(CupertinoIcons.delete,size: 30,color: Colors.black,)),],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                          },
                        ),
                      )


                    ],
                  ),
                ),
              ),


            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}

