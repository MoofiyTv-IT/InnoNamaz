import 'package:flutter/material.dart';
import 'package:inno_namaz/Utils/external_links.dart';
import 'package:inno_namaz/resources/fonts.dart';
import 'package:inno_namaz/resources/colors.dart';
import 'package:inno_namaz/resources/links.dart';

Future<void> productionDailog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: dialogBackground,
        title: Text('A MoofiyTV Production !' , style: TextStyle(color: Colors.white  , fontSize: 16 , fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        content: SingleChildScrollView(
          child: ListBody(  
            children: <Widget>[
              Text('Al-Salaamu \'alaikum,This non-profit app has been developed by MoofiyTvIT team as a thank you for the amazing Muslim people in Innopolis, and to get hasanat when people use it.\n\nI hope, it will help us all to not miss prayers and always listen to the beautiful sound of adhan.\n\nFeel free to contact us if you have any idea or suggestion, or if you want to develop an app or learn how to do it.' , style: TextStyle(color: Colors.white , fontSize: 14) , textDirection: TextDirection.ltr,),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('INSTAGRAM' , style: TextStyle(color: darkBlue ,fontFamily: letter_font,
                    fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),

          FlatButton(
            child: Text('YOUTUBE' , style: TextStyle(color: darkYellow ,fontFamily: letter_font,
                    fontStyle: FontStyle.normal, fontWeight: FontWeight.bold), ),
            onPressed: () {
              ExternalLinks().launchInBrowser(youtube_link);
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

Future<void> joinUsDailog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: dialogBackground,
        title: Text('Want to join us ?' , style: TextStyle(color: Colors.white  , fontSize: 16 , fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This App is an open-source project on Github. If you want to contribute and enhance it, you can find a to-do list of potential improvements in the Readme file.\n\nThank you and Keep coding!' , style: TextStyle(color: Colors.white , fontSize: 14) , textDirection: TextDirection.ltr,),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANSLE' , style: TextStyle(color: Colors.white ,fontFamily: letter_font,
                    fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),

          FlatButton(
            child: Text('GITHUB' , style: TextStyle(color: darkYellow ,fontFamily: letter_font,
                    fontStyle: FontStyle.normal, fontWeight: FontWeight.bold), ),
            onPressed: () => ExternalLinks().launchInBrowser(github_link),
          ),
        ],
      );
    },
  );
}