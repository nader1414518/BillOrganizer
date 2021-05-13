import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizer/main.dart';

class NavDrawer extends StatelessWidget {
  bool libraryExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.home_rounded),
            title: Text("Home"),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyHomePage(
                  title: "Home",
                );
              }))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Exit'),
            onTap: () async {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
