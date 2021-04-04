import 'package:flutter/material.dart';
import 'package:uts/model/home.dart';
import 'package:uts/model/homeKopsis.dart';

class DrawerNav extends StatefulWidget {
  @override
  _DrawerNavState createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Center(child:
              Text("       DETA FEBBY ARIESTA"+ "\n" + "UTS PEMROGRAMAN MOBILE"),
            ),
            ),
            ListTile(
              title: Text("Penjual Kopsis"),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeKopsis())),
            ),
            ListTile(
              title: Text("Data Barang"),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home())),
            ),
          ],
        ),
      ),
    );
  }
}