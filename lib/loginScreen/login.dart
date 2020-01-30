import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/starl/Documents/Github/hvz_flutter_app/lib/utilities/apiManager.dart';
import 'package:hvz_flutter_app/loginScreen/widgets/loginWidget.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'dart:developer' as developer;

import '../mainScreen/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  final String title = "Login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  final loadingDialogManager = LoadingDialogManager();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final apiManager = APIManager();

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
    int responseCode = await loadingDialogManager.performLoadingTask(
      context,
      apiManager.login(emailController.text, passwordController.text),
        () => _onError("Caught API error", "Unknown Error. Please contact the HvZ admin for assistance.")
    );

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


  void _onError(String devLog, String alert) {
    developer.log(devLog, name: "hvzloginapi");
    _showAlertDialog(context, alert);
  }
}



