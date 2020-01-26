import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hvz_flutter_app/apiManager.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  final String title = "Login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  final String assetName = 'assets/uwhvz-logo.svg';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  assetName,
                  semanticsLabel: 'HvZ Logo',
                )
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Column (
                      children: <Widget>[
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              fillColor: Color.fromRGBO(0, 0, 0, 0),
                              labelText: 'Email'
                          )
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password'
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: RaisedButton(
                            onPressed: () => submit(context),
                            child: Text('Login'),
                          ),
                        )
                      ]
                  )
                ),
              )
            ]
          )
        )
      ),
    );
  }

  void submit(BuildContext context) async {
    String success = await APIManager().getLogin(emailController.text, passwordController.text);
    showAlertDialog(context, success);
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Finished"),
      content: Text("Successful? " + message.toString()),
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
}



