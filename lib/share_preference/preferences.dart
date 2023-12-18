

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

    static late SharedPreferences _prefs;
    
    static String _name = '';
    static String _email = '';
    static bool _isDarkmode = false;
    static int _gender = 1;
    static String _newPictureFile = '';
    File? picture;
    static Future init() async{
     return _prefs = await SharedPreferences.getInstance();

    }
    static String get email{
      return _prefs.getString('email') ?? _email;
    }
    static set email(String email){
      _email = email;
      _prefs.setString('name', email);
    }
    static String get name{
      return _prefs.getString('name') ?? _name;
    }
    static set name(String name){
      _name = name;
      _prefs.setString('name', name);
    }

    static bool get isDarkmode{
      return _prefs.getBool('isDarkmode') ?? _isDarkmode;
    }
    static set isDarkmode(bool value){
      _isDarkmode = value;
      _prefs.setBool('isDarkmode', value);
    }

    static int get gender{
      return _prefs.getInt('gender') ?? _gender;
    }    
    static set gender(int value){
      _gender = value;
      _prefs.setInt('gender', value);
    }


    static String get newPictureFiles{
      return _prefs.getString('newPictureFile') ?? _newPictureFile;
    }    
    static set newPictureFiles(String value){
      _newPictureFile = value;
      _prefs.setString('newPictureFile', value);
      //File.fromUri(Uri(path: _newPictureFile));
    }




}