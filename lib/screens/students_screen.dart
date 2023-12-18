import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile_ces/models/students.dart';
import 'package:app_mobile_ces/models/users.dart';
import 'package:app_mobile_ces/screens/loading_screen.dart';
import 'package:app_mobile_ces/services/students_service.dart';
import 'package:app_mobile_ces/services/users_service.dart';
import 'package:app_mobile_ces/widgets/side_menu.dart';
import 'package:app_mobile_ces/widgets/students_card.dart';
import 'package:velocity_x/velocity_x.dart';

class StudentsScreen extends StatelessWidget {

  static const String routerName = 'Students';
  final Students? students;
  const StudentsScreen({key,  this.students}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentsService = Provider.of<StudentsService>(context);
    studentsService.loadStudents();
   /*  if( userssService.isLoading ) return LoadingScreen(); */
    print(studentsService.students);
  /*   userssService.users.forEach((usuario) {
  print('Nombre: ${usuario.name}, Email: ${usuario.email}, URL: ${usuario?.picture}');
}); */
    return  Scaffold(
          appBar:  AppBar(title: const Text('Students'),),
          drawer: const SideMenu(),
          body: ListView.builder(
        itemCount: studentsService.students.length,
        itemBuilder: ( BuildContext context, int index ) => GestureDetector(
          onTap: () {

            studentsService.selectedStudy = studentsService.students[index].copy();
            //Navigator.pushNamed(context, 'product');
          },
          child: StudentsCard(
            students: studentsService.students[index],
          ),
        )
      ),
      );
  }
}