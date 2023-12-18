import 'package:flutter/material.dart';
import 'package:app_mobile_ces/screens/screens.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {

    int admin = 1;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.pages_outlined),
            title: const Text('Home'),
            onTap: (){
              Navigator.pushReplacementNamed(context, Dashboard.routerName);

            },
          ),

          admin == 1 ? 
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('People'),
            onTap: (){
              Navigator.pushReplacementNamed(context, StudentsScreen.routerName);

            },
          ) : Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: (){
              Navigator.pushReplacementNamed(context, SettingsScreen.routerName);
            },
          ),

        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Container(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo.jpg'),
          fit:BoxFit.cover
          )
      ),
    );
  }
}