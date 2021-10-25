import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hue_helper/palette_input.dart';
import 'package:hue_helper/settings.dart';
import 'basic_widgets.dart';
import 'palette_type.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hue Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Be Vietnam Pro',
        scaffoldBackgroundColor: ThemeColors.backgroundColor,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget createNavButton(String text, Color buttonColor, Function nextScreen)
  {
    return Expanded(
      child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                ),),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () { nextScreen(); })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: [
          Expanded(
            flex: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('images/logo.png'),
                  fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
              flex: 50,
              child: Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    createNavButton('i need a palette', ThemeColors.primaryColor, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaletteType()),
                      );
                    }),
                    createNavButton('i have a palette', ThemeColors.secondaryColor, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaletteInput()),
                      );
                    }),
                    createNavButton('any palette, please', ThemeColors.tertiaryColor, () {
                     // Navigator.push(
                        //context,
                        //MaterialPageRoute(
                        //    builder: (context) => PaletteInput()),
                     // );
                    }),
                  ],
                ),
              )),
          createBottomRow(Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Settings()),
            );
          }),
        ],
      ),
    );
  }
}
