import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile_ces/config.dart';
import 'package:app_mobile_ces/models/users.dart';
import 'package:app_mobile_ces/providers/product_form_provider.dart';
import 'package:app_mobile_ces/providers/theme_provide.dart';
import 'package:app_mobile_ces/services/users_service.dart';
import 'package:app_mobile_ces/share_preference/preferences.dart';
import 'package:app_mobile_ces/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {


  final Users? users;

  static const String routerName = 'Settings';
  const SettingsScreen({super.key,   this.users});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {
    
    final userService = Provider.of<UsersService>(context);
    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( userService.selectedUser ), // Reemplaza "TuProveedor" con tu clase ChangeNotifier.
      child:  Scaffold(
          appBar:  AppBar(title: const Text('Settings'),),
          drawer: const SideMenu(),
          body: MiContenido(userService:userService)
      )
    );
  }
}


class MiContenido extends StatelessWidget {


   const MiContenido({
    Key? key,
     required this.userService,
  }) : super(key: key);


  final UsersService userService;


  
  @override
  Widget build(BuildContext context) {
    //userService.email="julio2@gmail.com";
    // Usa miProveedor para acceder a los datos y métodos que proporciona tu proveedor.
    /* final userService = Provider.of<UsersService>(context);

    userService.loadUsers("julio2@gmail.com");  */
    /* final userService = Provider.of<UsersService>(context); */

        final productForm = Provider.of<ProductFormProvider>(context);

          return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // Contenido principal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 250),
                    const Divider(),
                    
                    buildSwitchListTile(context),

                    const Divider(),
                    buildGenderRadioListTile(context, 1, 'Masculino'),

                    const Divider(),
                    buildGenderRadioListTile(context, 2,'Femenino'),
                    const Divider(),
                    buildNameTextField(context),

                    const Divider(),
                  ],
                ),
                // Icono de la cámara
                buildCameraIconButton(context),

                // Imagen de perfil
                buildProfileImage(context),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton:buildSaveButton(context),
        );

     /*  */

      /* floatingActionButton: _fabLocation
            ? FloatingActionButton(
                onPressed: () {},
                tooltip: 'Create',
                child: const Icon(Icons.add),
              )
            : null,
          ); */
          
          // ... Tu contenido ...



    
  
  
  }

  Widget buildSwitchListTile(BuildContext context) {
  return SwitchListTile.adaptive(
    value: Preferences.isDarkmode,
    title: const Text('DarkMode'),
    onChanged: (value) {
      Preferences.isDarkmode = value;
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      value ? themeProvider.setDarkMode() : themeProvider.setLightMode();
    },
  );
}

Widget buildGenderRadioListTile(BuildContext context, int value, String title) {
  return RadioListTile<int>(
    value: value,
    groupValue: Preferences.gender,
    title: Text(title),
    onChanged: (newValue) {
      Preferences.gender = newValue ?? 1;
    },
  );
}

Widget buildNameTextField(BuildContext context) {
  final userService = Provider.of<UsersService>(context);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextFormField(
      initialValue:  (Preferences.name=='' ? userService.users[0].name  : Preferences.name),
      onChanged: (value)  {
         
        Preferences.name = value;
       
      },
      decoration: const InputDecoration(
        labelText: 'Nombre',
        helperText: 'Nombre del usuario',
      ),
    ),
  );
}

Widget buildCameraIconButton(BuildContext context) {
  return Positioned(
    top: 0,
    right: 0,
    child: IconButton(
      onPressed: () async {
        final picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 60,
        );
        if (pickedFile == null) {
          return;
        }
        Provider.of<UsersService>(context, listen: false)
            .updateSelectedUserImage(pickedFile.path);
      },
      icon: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white),
    ),
  );
}

Widget buildProfileImage(BuildContext context) {
  final Imagenback = Provider.of<UsersService>(context);
  return Positioned(
    top: 50,
    left: 20,
    child: ProfileImage(url:  Imagenback.users[0].picture!=null || Imagenback.users[0].picture!='' ? Imagenback.users[0].picture : Provider.of<UsersService>(context).selectedUser.picture),
  );
}

Widget buildSaveButton(BuildContext context) {
  final userService = Provider.of<UsersService>(context);
  return FloatingActionButton(
    child: Provider.of<UsersService>(context).isSaving
        ? CircularProgressIndicator(color: Colors.white)
        : const Icon(Icons.save_outlined),
    onPressed: Provider.of<UsersService>(context).isSaving
        ? null 
        : () async {
            final productForm = Provider.of<ProductFormProvider>(context, listen: false);
            
            final String? imageUrl = await Provider.of<UsersService>(context, listen: false).uploadImage();
      
            userService.users[0].picture = imageUrl;

            await Provider.of<UsersService>(context, listen: false).saveOrCreateProduct(userService.users[0]);

          },
  );
}
}
