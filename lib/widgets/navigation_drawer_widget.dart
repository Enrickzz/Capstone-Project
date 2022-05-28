import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget{
  final padding = EdgeInsets.symmetric(horizontal:20);

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Material(
        color: Color.fromRGBO(50, 75, 205, 1),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            buildMenuItem(
              text:'Add Patient',
              icon: Icons.people,
              onClicked: () =>selectedItem(context, 0)
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              text:'Profile',
              icon: Icons.people,
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              text:'Notifications',
              icon: Icons.people,
            ),
            const SizedBox(height: 24,),
            Divider(color: Colors.white,),
            buildMenuItem(
              text:'Signout',
              icon: Icons.people,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
     String text,
     IconData icon,
    VoidCallback onClicked,
  }){
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: (){},

    );
  }
  void selectedItem(BuildContext context, int index){

    switch(index){
      case 0:

        break;
    }
  }

}