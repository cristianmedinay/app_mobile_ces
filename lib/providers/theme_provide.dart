import 'dart:io';

import 'package:flutter/material.dart';




class ThemeProvider extends ChangeNotifier{

    ThemeData currentTheme;
    File? picture;
    ThemeProvider({
      required bool isDarkmode
    }): currentTheme = isDarkmode ? ThemeData.dark() : ThemeData.light();


    setLightMode(){
      currentTheme = ThemeData.light();
      notifyListeners();
    }
    setDarkMode(){
      currentTheme = ThemeData.dark();
      notifyListeners();
    }
    setPickture(){
      currentTheme = ThemeData.dark();
      notifyListeners();
    }

    void updateSelectImage(String path){
        File.fromUri(Uri(path: path));
        notifyListeners();

    }


}
