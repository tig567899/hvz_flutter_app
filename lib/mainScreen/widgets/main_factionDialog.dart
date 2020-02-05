
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/models/faction.dart';
import 'package:hvz_flutter_app/models/modifier.dart';
import 'package:hvz_flutter_app/models/playerInfo.dart';

class FactionDialog extends AlertDialog {
  BuildContext parentContext;
  Faction faction;
  Widget dismiss;

  FactionDialog(this.parentContext, this.faction, this.dismiss);

  @override
  List<Widget> get actions => <Widget>[dismiss];

  @override
  Widget get content => Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Theme.of(parentContext).primaryColor,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Faction",
                          textScaleFactor: 3.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                  )
                ]
            ),
            Container (
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text (
                faction.name,
                textScaleFactor: 2.0,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container (
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                faction.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
            ..._getFactionModifierDisplays()
          ]
      )
  );

  List<Widget> _getFactionModifierDisplays() {
    List<Widget> modifiers = List();

    modifiers.add(
      Container (
        margin: EdgeInsets.all(5),
        child: Text(
          "Perks",
          textScaleFactor: 1.6,
          style: TextStyle(
            decoration: TextDecoration.underline
          ),
        ),
      )
    );

    faction.modifiers.forEach((element) {
      modifiers.add(
        Text(getModifierString(element))
      );
    });

    return modifiers;
  }

  String getModifierString(Modifier modifier) {
    String amountstr = modifier.amount.toString();
    if (modifier.amount > 0) {
      amountstr = "+${modifier.amount}";
    }
    if (modifier.type == "O") {
      return "A one-time bonus of ${modifier.amount} points";
    } else if (modifier.type == "S") {
      return "$amountstr points on every supply code redeemed";
    } else if (modifier.type == "T") {
      return "$amountstr points on every stun";
    } else {
      return "Unknown faction perk. If you see this, contact the moderator team.";
    }
  }

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0);
}