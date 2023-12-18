import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile_ces/providers/theme_provide.dart';
import 'package:app_mobile_ces/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:app_mobile_ces/services/students_service.dart';
import 'package:app_mobile_ces/services/users_service.dart';
import 'dart:convert';

import 'package:app_mobile_ces/share_preference/preferences.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await Preferences.init();
   runApp(
      AppState(prefs_:prefs.getString('token'))
    );
}


class AppState extends StatelessWidget{
    final prefs_;
    const AppState({
      @required this.prefs_,
      Key? key,
    }): super(key: key);
    Widget build(BuildContext context){
      return MultiProvider(
      providers:[ 
        ChangeNotifierProvider(create: ( _ )=> ThemeProvider(isDarkmode: Preferences.isDarkmode),),
        ChangeNotifierProvider(create: ( _ ) => UsersService()),
        ChangeNotifierProvider(create: ( _ ) => StudentsService()),

      ],
      child:  MyApp(token: prefs_),
      );

    }

}


class MyApp extends StatelessWidget {
  
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }): super(key: key);

  static const String _title = 'MPKnife';
 
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: _title,
      initialRoute: SignInPage.routerName,
      //theme: Preferences.isDarkmode ? ThemeData.dark() : ThemeData.light(),
      theme: Provider.of<ThemeProvider>(context).currentTheme,
     
      home: (token != null && JwtDecoder.isExpired(token) == false ) ? Dashboard(token: token):SignInPage(),

      routes: {
        Dashboard.routerName : (_)=> Dashboard(token: token),
        StudentsScreen.routerName : (_)=> StudentsScreen(),
        SettingsScreen.routerName : (_)=> SettingsScreen(),
      
      },

    );
  }
}