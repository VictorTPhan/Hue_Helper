import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hue_helper/finished_palette.dart';
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

  //creates a random palette and sends the user to the finished palette screen.
  void generateRandomPalette()
  {
    //generate a starting color and fill the palette with it
    HSLColor startingColor = HSLColor.fromColor(Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
    List<HSLColor> generatedPalette = List.filled(Random().nextInt(5)+2, startingColor); //random.nextInt(5) returns 0 to 4, add 2 to generate between 2 to 6 colors.

    //this will be changed, it is assigned a default value because otherwise the compiler will raise an error
    PaletteOrganization generatedType = PaletteOrganization.analogous;
    int generatedIndex = Random().nextInt(3);

    //decide what type of palette this is going to be
    switch(generatedIndex)
    {
      case 0: generatedType = PaletteOrganization.analogous; break;
      case 1: generatedType = PaletteOrganization.complementary; break;
      case 2: generatedType = PaletteOrganization.monochromatic; break;
    }

    //depending on palette type, the range for hue variation will be different
    double hueLow, hueHigh;
    double satLow = 40, satHigh = 80;
    double lumLow = 20, lumHigh = 90;

    if (generatedType == PaletteOrganization.analogous) {hueLow = 90; hueHigh = 180;}
    else {hueLow = 0; hueHigh = 90;}

    //generate our variances
    double hueVariance, saturationVariance, luminanceVariance;

    hueVariance = hueLow+ Random().nextInt((hueHigh-hueLow).toInt());
    saturationVariance = (satLow+ Random().nextInt((satHigh-satLow).toInt()))/100;
    luminanceVariance = (lumLow+ Random().nextInt((lumHigh-lumLow).toInt()))/100;

    generatedPalette = calculateOtherColors(generatedType, generatedPalette, generatedPalette.length, hueVariance, saturationVariance, luminanceVariance);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FinishedPalette(finalPalette: generatedPalette)),
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
                      generateRandomPalette();
                    }),
                  ],
                ),
              )),
          Expanded(
            flex: 10,
            child: Container(),
          )
        ],
      ),
    );
  }
}
