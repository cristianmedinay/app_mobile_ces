import 'package:flutter/material.dart';

import 'package:app_mobile_ces/models/users.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Users users;

  ProductFormProvider( this.users );

  updateAvailability( bool value ) {
    print(value);
    this.users.available = value;
    notifyListeners();
  }


  bool isValidForm() {

    print( users.name );
    print( users.available );


    return formKey.currentState?.validate() ?? false;
  }

}