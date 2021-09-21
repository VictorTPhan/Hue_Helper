import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hue_helper/palette_input.dart';
import 'package:hue_helper/settings.dart';
import 'palette_type.dart';

void main() {
  runApp(MyApp());
}

class ThemeColors {
  static const primaryColor = Color(0xFF005CE7);
  static const secondaryColor = Color(0xFF1A75FF);
  static const tertiaryColor = Color(0xFF3D8BFF);
  static const fourthColor = Color(0xFF61A0FF);
  static const backgroundColor = Color(0xFFD1E3FF); //should be very light
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ThemeColors.primaryColor,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                              ),),
                              child: Text(
                                'i need a palette',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaletteType()),
                                );
                              })),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ThemeColors.secondaryColor,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                              ),),
                              child: Text(
                                'i have a palette',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    //TODO: create a palette input class
                                      builder: (context) => PaletteInput()),
                                );
                              })),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ThemeColors.tertiaryColor,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                              ),),
                              child: Text(
                                'any palette, please',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                //Navigator.push(
                                  //context,
                                  //MaterialPageRoute(
                                    //TODO: Create a random palette descriptor generator and send that data to the finished palette screen
                                      //builder: (context) => FinishedPalette()),
                                //);
                              })),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ThemeColors.fourthColor,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                              ),),
                              child: Text(
                                'my palettes',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {})),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: Size.fromHeight(100),
                          backgroundColor: ThemeColors.fourthColor,
                          shape: CircleBorder(),
                        ),
                        child: Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //TODO: Create a settings screen
                                builder: (context) => Settings()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
