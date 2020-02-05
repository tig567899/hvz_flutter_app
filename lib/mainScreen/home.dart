import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'file:///C:/Users/starl/Documents/Github/hvz_flutter_app/lib/utilities/apiManager.dart';

import '../applicationData.dart';
import '../constants.dart';
import '../models/playerInfo.dart';
import 'widgets/mainWidget.dart';
import 'widgets/tagStunWidget.dart';
import 'widgets/twitterWidget.dart';

class DrawerItem {
  String text;
  DrawerState key;
  DrawerItem(this.text, this.key);
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  APIManager apiManager = APIManager();

  final String routeName = "HomePage";

  final drawerItems = [
    DrawerItem("Player Dashboard", DrawerState.PROFILE),
    DrawerItem("Report a tag or stun", DrawerState.TAG_STUN),
    DrawerItem("Twitter Feed", DrawerState.TWITTER),
  ];

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ApplicationData appData = ApplicationData();

  DrawerState _selectedDrawerState = DrawerState.PROFILE;
  String _title = "Player Dashboard";

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

  @override
  void initState() {
    widget.apiManager.setCookieJarInterceptor();
  }

  _onSelectDrawerItem(DrawerItem item) {
    setState(() {
      _selectedDrawerState = item.key;
      _title = item.text;
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
            onTap: () => _onSelectDrawerItem(item),
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
              title: Text(_title),

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

  void _logout(BuildContext context) async {
    int statusCode = await LoadingDialogManager()
        .performLoadingTask(context, widget.apiManager.logout(), _returnToLogout);
    if (statusCode != 200) {
      return;
    } else {
      _returnToLogout();
    }
  }

  void _returnToLogout() {
    appData.info = PlayerInfo();
    appData.loggedIn = false;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}