import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:app_mobile_ces/models/students.dart';


class StudentsService extends ChangeNotifier {


  final List<Students> students = [];

  late Students selectedStudy;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  String? email;
  String? picture;
  StudentsService(){
    loadStudents();

  }

  Future loadStudents() async {

      var resp = await http.post(Uri.http('192.168.1.38:3000','allusers'),
      headers: {"Content-Type":"application/json"});

      var studentsList = json.decode(resp.body);
       // Asegúrate de que Students sea el tipo correcto

      for (var studentMap in studentsList) {
        Students user = Students.fromMap(studentMap);

        bool emailExists = this.students.any((user2) => user2.email == user.email);

        if (!emailExists) {
          this.students.add(user);
        }
      }

      print(this.students);

      return this.students;
     /*  Students user = Students.fromMap(StudentsMap);
      
      bool emailExists = this.students.any((user2) => user2.email == user.email);

      if (!emailExists) {
        this.students.add(user);
      }

      print(this.students);      
  
      return this.students; */
  }
 



 


}