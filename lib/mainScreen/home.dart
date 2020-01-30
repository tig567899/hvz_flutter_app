import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../applicationData.dart';
import '../constants.dart';
import '../playerData.dart';
import 'drawerLayouts/mainWidget.dart';
import 'drawerLayouts/tagStunWidget.dart';
import 'drawerLayouts/twitterWidget.dart';

class DrawerItem {
  String text;
  DrawerState key;
  DrawerItem(this.text, this.key);
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  final String title = "UWaterloo Humans vs Zombies";

  final drawerItems = [
    DrawerItem("Profile", DrawerState.PROFILE),
    DrawerItem("Report a tag or stun", DrawerState.TAG_STUN),
    DrawerItem("Twitter Feed", DrawerState.TWITTER),
  ];

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ApplicationData appData = ApplicationData();

  DrawerState _selectedDrawerState = DrawerState.PROFILE;

  _getDrawerItemWidget(DrawerState state) {
    switch(state) {
      case DrawerState.PROFILE:
        return MainWidget();
      case DrawerState.TAG_STUN:
        return TagStunWidget();
      case DrawerState.TWITTER:
        return TwitterWidget();
      default:
        return Text(
            "An error has occured. Please contact the HvZ executive team."
        );
    }
  }

  _onSelectDrawerItem(DrawerState state) {
    setState(() {
      _selectedDrawerState = state;
    });
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[
      DrawerHeader(
        child: SvgPicture.asset("assets/site-logo-dark.svg"),
        decoration: BoxDecoration(
            color: Colors.black87
        ),
      ),
    ];
    widget.drawerItems.forEach((item) {
      drawerOptions.add(
          new ListTile(
            title: new Text(item.text),
            selected: item.key == _selectedDrawerState,
            onTap: () => _onSelectDrawerItem(item.key),
          )
      );
    });

    drawerOptions.add(
      new ListTile(
        title: Text("Log out"),
        onTap: () => _logout(context),
      )
    );

    return WillPopScope (
        onWillPop: () async => false, // Disables Android back button
        child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),

            ),
            drawer: Drawer (
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: drawerOptions
                )
            ),
            body: _getDrawerItemWidget(_selectedDrawerState)
        )
    );
  }

  void _logout(BuildContext context) {
    appData.info = PlayerInfo();
    appData.loggedIn = false;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}