import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:app_mobile_ces/models/users.dart';


class UsersService extends ChangeNotifier {

  final String _baseUrl = '192.168.1.38:3000/signin';
  final List<Users> users = [];

  late Users selectedUser;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  String? email;
  String? picture;
  UsersService(){
    this.loadUsers;

  }

  Future<List<Users>> loadUsers(String? notyEmail) async {
  //Future<List<Users>> loadUsers() async {

      /* this.isLoading = true;
      notifyListeners(); */
      var regBody = {
        "email":notyEmail
      };
      var resp = await http.post(Uri.http('192.168.1.38:3000','users'),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(regBody));

      final Map<String,dynamic> UsersMap = json.decode(resp.body);
      /*  UsersMap.forEach((key, value) {
        print(value);
      final user = Users.fromMap(value);
    
      this.users.add( user );
      });
      */
      Users user = Users.fromMap(UsersMap);
    
      
      bool emailExists = this.users.any((user2) => user2.email == user.email);

      if (!emailExists) {
        this.users.add(user);
      }

      print(UsersMap);
      
  
      return this.users;
  }
 void updateSelectedUserImage( String path ) {

    this.selectedUser.picture = path;
    this.newPictureFile = File.fromUri( Uri(path: path) );

    notifyListeners();

  }



 
  Future<String?> uploadImage() async {

    if (  this.newPictureFile == null  ) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dqx40orev/image/upload?upload_preset=mesmkztn');
    final imageUploadRequest = http.MultipartRequest('POST', url );
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );

    /*   print(decodedData); */
   
    return decodedData['secure_url'];
 

    /* 
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dqx40orev/image/upload');
    final imageUploadRequest = http.MultipartRequest('POST', url )
                              ..fields['upload_preset'] = 'mesmkztn'
                              ..files.add(await http.MultipartFile.fromPath('file', newPictureFile!.path));
                              
     final response = await imageUploadRequest.send();           

      if(response.statusCode==200){

      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
    }                   
                               */
   
   
    //imageUploadRequest.files.add(file);
    
   

  /*   final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }
    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );

          print( decodedData ); */

  /*   if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url']; */

  }


  
       
  Future<String?> updateProduct( Users user ) async {
 
   var regBody = {
        "email":user.email,
        "url":user.picture,
      };
   
    final resp = await http.post(Uri.http( '192.168.1.38:3000','updated'), headers: {"Content-Type":"application/json"}, body:jsonEncode(regBody));

    final  UsersMap = json.decode(resp.body);
    
    final decodedData = resp.body;

    //TODO: Actualizar el listado de productos
    final index = this.users.indexWhere((element) => element.id == user.id );
    this.users[index] = user;

    return user.id!;

  }
/* 


  Future<String> createProduct( Users users ) async {

    final url = Uri.https( _baseUrl, 'products.json');
    final resp = await http.post( url, body: product.toJson() );
    final decodedData = json.decode( resp.body );

    product.id = decodedData['name'];

    this.products.add(product);
    

    return product.id!;

  } */
  

  
  Future saveOrCreateProduct( Users users ) async {

 /*    isSaving = true;
    notifyListeners(); */
    
    if ( users.id == null ) {
      // Es necesario crear
      //await this.createProduct( users );

    } else {
      // Actualizar
      await this.updateProduct( users );
    }



/*     isSaving = false;
    notifyListeners(); */

  }
  

}