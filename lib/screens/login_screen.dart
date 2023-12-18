import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile_ces/models/users.dart';
import 'package:app_mobile_ces/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_mobile_ces/services/users_service.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class SignInPage extends StatefulWidget {

  
  static const String routerName = 'Login';
  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async{
    if(emailController.text.isNotEmpty || passwordController.text.isNotEmpty){

     
       var reqBody = {
        "email":emailController.text,
        "password":passwordController.text
      };
      /* final urx = 'http://192.168.1.37:3000/users'; */
      var response = await http.post(Uri.parse('http://192.168.1.38:3000/signin'),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(reqBody)
      );
      /* print('Response body: ${response.body}'); */

      /*
      var jsonResponse = jsonDecode(response.body);
       print(jsonResponse); */
      //var url = Uri.http('localhost:3000', '/signin');
      //var response = await http.post(Uri.parse(login),
      var jsonResponse = jsonDecode(response.body);
      
       if(jsonResponse['status']){
          var myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(token: myToken)));
      }else{
        print('Something went wrong');
      }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter proper email and password')),
        );
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);

    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Login'),),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0XFFF95A3B),const Color(0XFFF96713)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                stops: [0.0,0.8],
                tileMode: TileMode.mirror
            ),
          ),
          child: Center(

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: <Widget>[
                  Container(
                  margin: EdgeInsets.only(top:50,bottom: MediaQuery.of(context).size.height*0.05),
                  child: Image.asset('assets/logo_inicio.jpg',width: 200,height: 200,)),
                  
                  "Email Sign-In".text.size(22).yellow100.make(),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0),
                        hintText: "Email",
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0),
                        hintText: "Password",
                        errorText: _isNotValidate ? "Enter Proper Info" : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(),
                  GestureDetector(
                    onTap: (){
                       userService.selectedUser = new Users(
                        available: false, 
                        name: '', 
                      
                      );
                       loginUser();
                    },
                    child: HStack([
                      VxBox(child: "LogIn".text.white.makeCentered().p20()).green600.roundedLg.make(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
          },
          child: Container(
              height: 25,
              color: Colors.lightBlue,
              child: Center(child: "Create a new Account..! Sign Up".text.white.makeCentered())),
        ),
      ),
    );
  }
}