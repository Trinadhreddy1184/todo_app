import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Fire{

  updatemap(task,val){
    Firebase.initializeApp();
    FirebaseFirestore.instance.collection('todos').doc('todolist').update({task:val});
  }
  removemap(task){
    Firebase.initializeApp();
    FirebaseFirestore.instance.collection('todos').doc('todolist').update({task: FieldValue.delete()});
  }
  renamemap(Map tasks){
    Firebase.initializeApp();
    FirebaseFirestore.instance.collection('todos').doc('todolist').delete();
    FirebaseFirestore.instance.collection('todos').doc('todolist').set({});
    tasks.forEach((key, value) {
      FirebaseFirestore.instance.collection('todos').doc('todolist').update({key:value});
    });
    //FirebaseFirestore.instance.collection('todos').doc('todolist').update({taskname: FieldValue.arrayRemove()});
  }

}