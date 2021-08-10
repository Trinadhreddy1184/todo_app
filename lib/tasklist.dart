import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'fire.dart';
class TaskList extends ChangeNotifier{
  Map tasks={};
  int taskcount(){
    //notifyListeners();
    return tasks.length;
  }
  updatetask(){
    FirebaseFirestore.instance.collection("todos").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.data().forEach((key, value) {tasks[key]=value;});
      });
      print(tasks);
      notifyListeners();
    });
  }

  addtask(value) {
    tasks[value]=false;
    Fire().updatemap(value,false);
    notifyListeners();

  }
  checktask(taskname,value){
    tasks[taskname]=value;
    Fire().updatemap(taskname,value);
    notifyListeners();
  }
  deletetask(taskname){
    tasks.remove(taskname);
    Fire().removemap(taskname);
    notifyListeners();
  }
  renamekey(index,newname){
    List keys= tasks.keys.toList();
    List values =tasks.values.toList();
    keys[index]=newname;
    tasks.clear();
    tasks=Map.fromIterables(keys, values);
    Fire().renamemap(tasks);
    notifyListeners();
  }

}