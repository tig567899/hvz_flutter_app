import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/apiManager.dart';
import 'package:hvz_flutter_app/loginScreen/widgets/loginWidget.dart';
import 'package:hvz_flutter_app/loginScreen/widgets/progressWidget.dart';
import 'dart:developer' as developer;

import '../mainScreen/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  final String title = "Login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LoginWidget(emailController, passwordController, submit)
    );
  }

  void submit() async {
    _showLoadingDialog(context);
    int responseCode = 0;

    try {
      responseCode = await APIManager().getLogin(emailController.text, passwordController.text);
    } catch(e) {
      await Future.delayed(Duration(seconds: 2));
      _hideLoadingDialog();
      _onError("Caught API error", "Unknown Error. Please contact the HvZ admin for assistance.");
      return;
    }
    await Future.delayed(Duration(seconds: 2));
    developer.log("Popping", name:"hvzapilogin");
    _hideLoadingDialog();
    switch(responseCode) {
      case 200:
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => HomePage()
            ));
        return;
      case 403:
      case 404:
        _showAlertDialog(context, "Invalid Credentials. Please try again.");
        return;
      case 500:
        _showAlertDialog(context, "Interal Server Error. Please contact the HvZ admin for assistance.");
        return;
      default:
        _showAlertDialog(context, "Unknown Error. Please contact the HvZ admin for assistance.");
        return;
    }
  }

  _showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(message.toString()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    isLoading = true;
    AlertDialog progress = AlertDialog(
      content: Row (
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Loading..."),
          )
        ]
      )
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return progress;
      }
    );
  }

  void _hideLoadingDialog() {
    if (isLoading) {
      isLoading = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _onError(String devLog, String alert) {
    developer.log(devLog, name: "hvzloginapi");
    _showAlertDialog(context, alert);
  }
}



