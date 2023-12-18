import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile_ces/models/users.dart';
import 'package:app_mobile_ces/services/students_service.dart';
import 'package:app_mobile_ces/services/users_service.dart';
import 'package:app_mobile_ces/widgets/side_menu.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {

  static const String routerName = 'Dashboard';
  final Users? users;

  final token;
  const Dashboard({@required this.token,Key? key, this.users}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late String email;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;
  int? totalTodos;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['UserInfo']['email'];
    getTodoList(email);
  }

  void addTodo() async {
    if(_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty){

      var regBody = {
        "email":email,
        "items" :{"_id":DateTime.now().millisecondsSinceEpoch,"title":_todoTitle.text,"description":_todoDesc.text}
      };

      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);


      if(jsonResponse['status']){
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(email);
      }else{
        print("SomeThing Went Wrong");
      }
    }
  }

  void getTodoList(email) async {
    var regBody = {
      "email":email
    };

    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );
   var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['items'];
    totalTodos = items?.length ?? 0;
    setState(() {
    });
  }

  void deleteItem(id) async{
    var regBody = {
      "id":id,
      "email":email
    };
    
    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );
    var jsonResponse = jsonDecode(response.body);
  
    if(jsonResponse['status']){
      getTodoList(email);
    }

  }
 
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final studentsService = Provider.of<StudentsService>(context);
    studentsService.loadStudents();
    userService.loadUsers(email); 
    //userService.users[0].email=email;
     final userEmail = userService.users.isNotEmpty ? userService.users[0].email : "";
   /*  print(userService.users[0].email); */
    return Scaffold(
       backgroundColor: Colors.lightBlueAccent,
       appBar: AppBar(title: Text('Dashboard'),),
       drawer: const SideMenu(),
       body: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             padding: EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Text('Email: ${userEmail}',style: const TextStyle(fontSize: 15.0,fontWeight: FontWeight.w700),),
                  Divider(),
                 Text('Tareas',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700),),
                 SizedBox(height: 8.0),
                 Text('Total: ${totalTodos ?? 0}',style: TextStyle(fontSize: 15),),

               ],
             ),
           ),
           Expanded(
             child: Container(
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
               ),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: items == null ? null : ListView.builder(
                     itemCount: items!.length,
                     itemBuilder: (context,int index){
                       return Slidable(
                         key: const ValueKey(0),
                         endActionPane: ActionPane(
                           motion: const ScrollMotion(),
                           dismissible: DismissiblePane(onDismissed: () {}),
                           children: [
                             SlidableAction(
                               backgroundColor: Color(0xFFFE4A49),
                               foregroundColor: Colors.white,
                               icon: Icons.delete,
                               label: 'Delete',
                               onPressed: (BuildContext context) {
                                 print('${items![index]['_id']}');
                                 deleteItem('${items![index]['_id']}');
                               },
                             ),
                           ],
                         ),
                         child: Card(
                           borderOnForeground: false,
                           child: ListTile(
                             leading: Icon(Icons.task),
                             title: Text('${items![index]['title']}'),
                             subtitle: Text('${items![index]['description']}'),
                             trailing: Icon(Icons.arrow_back),
                           ),
                         ),
                       );
                     }
                 ),
               ),
             ),
           )
         ],
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_displayTextInputDialog(context) ,
        child: Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add To-Do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  TextField(
                    controller: _todoTitle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 5, 5, 5),
                      hintText: "Title",
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _todoDesc,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0),
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  ElevatedButton(onPressed: (){
                    addTodo();
                  }, child: Text("Add"))
              ],
            )
          );
        });
  }
}

