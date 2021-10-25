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

    if (generatedType == PaletteOrganization.analogous) {hueLow = 90; hueHigh = 180;}
    else {hueLow = 0; hueHigh = 90;}

    //generate our variances
    double hueVariance, saturationVariance, luminanceVariance;

    hueVariance = hueLow+ Random().nextInt((hueHigh-hueLow).toInt());
    saturationVariance = Random().nextDouble();
    luminanceVariance = Random().nextDouble();

    generatedPalette = calculateOtherColors(generatedType, generatedPalette, generatedPalette.length, hueVariance, saturationVariance, luminanceVariance);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FinishedPalette(finalPalette: generatedPalette)),
    );
  }

  //depending on the palette organization, this will assign them differently
  //assume palette[0] = adjustedColor
  List<HSLColor> calculateOtherColors(PaletteOrganization type, List<HSLColor> palette, int _paletteSize, double _hueVarianceValue, double _saturationVarianceValue, double _luminanceVarianceValue)
  {
    HSLColor referenceColor = palette[0];
    double hueVariance = _hueVarianceValue/_paletteSize;
    double saturationVariance = _saturationVarianceValue/_paletteSize;

    int halfWay = (_paletteSize/2).round();

    switch(type)
    {
      case PaletteOrganization.monochromatic:

      //at luminanceVariance = 0, the colors should all be the base color
      //at luminanceVariance = 1, the colors should range from pitch black to pure white

        double negLumRange = referenceColor.lightness * (_luminanceVarianceValue/1.0);
        for (int i = 1; i <= halfWay; i++)
        {
          palette[i-1] = referenceColor.withLightness(referenceColor.lightness - negLumRange * ((halfWay-i+1)/halfWay));
        }

        double posLumRange = (1-referenceColor.lightness) * (_luminanceVarianceValue/1.0);
        for (int i = halfWay+2; i <= _paletteSize; i++)
        {
          palette[i-1] = referenceColor.withLightness(referenceColor.lightness + posLumRange *(i/_paletteSize));
        }

        //subtly change hue and saturation
        for (int i = 0; i<_paletteSize; i++) {
          double hueDelta = referenceColor.hue + hueVariance * i;
          if (hueDelta < 0) hueDelta+=360;
          if (hueDelta > 360) hueDelta-=360;
          palette[i] = palette[i].withHue(hueDelta);

          palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVariance * i).clamp(0, 1));
        }

        return palette;
      case PaletteOrganization.analogous:

        double posLumRange = (1-referenceColor.lightness) * (_luminanceVarianceValue/1.0);

        for (int i = 0; i<_paletteSize; i++)
        {
          //change luminance
          palette[i] = referenceColor.withLightness(referenceColor.lightness + posLumRange * (i/_paletteSize));

          //change saturation
          palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVariance * i).clamp(0, 1));

          //change hues
          double hueDelta = referenceColor.hue + hueVariance * i;
          if (hueDelta < 0) hueDelta+=360;
          if (hueDelta > 360) hueDelta-=360;
          palette[i] = palette[i].withHue(hueDelta);
        }
        return palette;
      case PaletteOrganization.complementary:
        double saturationVarianceComplementary = _saturationVarianceValue/2;
        double oppositeHue = (180-referenceColor.hue).abs();
        double posLumRange = (1-referenceColor.lightness) * (_luminanceVarianceValue/1.0);

        for (int i = 0; i< halfWay; i++)
        {
          palette[i] = referenceColor.withLightness(referenceColor.lightness + posLumRange * ((i+1)/halfWay));

          double hueDelta = referenceColor.hue + hueVariance * i;
          if (hueDelta < 0) hueDelta+=360;
          if (hueDelta > 360) hueDelta-=360;
          palette[i] = palette[i].withHue(hueDelta);

          palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVarianceComplementary * i).clamp(0, 1));
        }

        for (int i = halfWay; i< _paletteSize; i++)
        {
          palette[i] = referenceColor.withLightness(referenceColor.lightness + posLumRange * (i-2)/(_paletteSize-halfWay));

          double hueDelta = (oppositeHue - hueVariance * (i-halfWay));
          if (hueDelta < 0) hueDelta+=360;
          if (hueDelta > 360) hueDelta-=360;
          palette[i] = palette[i].withHue(hueDelta);

          palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVarianceComplementary).clamp(0, 1));
        }
        return palette;
    }
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
