import 'package:flutter/material.dart';
import 'package:hue_helper/palette_type.dart';

import 'main.dart';

class PaletteAnalysis extends StatelessWidget {
  const PaletteAnalysis({Key? key, required this.palette}) : super(key: key);

  final List<Color> palette;

  void determinePaletteType(List<int> values)
  {
    //sort values from lowest to highest
    values.sort();

    //represents the distance between hue in colors
    List<int> hueDeltas = List.filled(palette.length-1, 0);

    for(int i = 0; i<values.length-1; i++)
    {
      int hueDelta = values[i+1]-values[i];
      hueDeltas[i] = hueDelta;
    }

    int amountOfColors = 1;

    for(int i = 0; i<hueDeltas.length; i++)
    {
      //hue variance is an arbitrary number and is hardcoded
      if (hueDeltas[i] > 25)
        {
          amountOfColors++;
        }
    }

    List<int> colorIndices = List.filled(amountOfColors, 0, growable: true);
    colorIndices[0] = 0;

    int currentColorIndex = 1;
    for(int i = 0; i<hueDeltas.length; i++)
    {
      //hue variance is an arbitrary number and is hardcoded
      if (hueDeltas[i] > 25)
      {
        colorIndices[currentColorIndex] = i+1;
        currentColorIndex++;
      }
    }

    print(colorIndices.toString());

    print("amount of colors: " + amountOfColors.toString());
  }

  @override
  Widget build(BuildContext context) {

    List<int> hueValues = List.filled(palette.length, 0);

    //save all values into hueValues
    for(int i = 0; i<palette.length; i++)
      {
        hueValues[i] = HSLColor.fromColor(palette[i]).hue.toInt();
      }

    determinePaletteType(hueValues);

    return Scaffold(
        body: Center(
        child: Column(
        children: [
          Expanded(
          flex: 10,
          child: Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Text(
              'palette analysis',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          Expanded(
            flex: 20,
            child: Container(
              margin: EdgeInsets.only(left: 3.0, right: 3.0),
              child: Row(
                children: [
                  for (var i in palette)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: i,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        margin: EdgeInsets.all(3.0),
                      ),
                    )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFEFFFF00),
                    Color(0xFE00FF00),
                    Color(0xFE00FFFF),
                    Color(0xFE0000FF),
                    Color(0xFEFF00FF),
                    Color(0xFFFF0000)],
                )
              ),
              child: Stack(
                children: [
                  for (var i in hueValues)
                    Positioned(
                        left: i/360 * MediaQuery.of(context).size.width,
                        child: Text(
                            i.toString(),
                        ),
                    )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 50,
              child: Column(
                children: [
                  //palette type
                  //color distribution
                  //lightness contrast
                  //saturation contrast
                  //descriptors
                ],
              )
          ),
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
                      child: Icon(Icons.arrow_forward, color: Colors.black),
                      onPressed: () {
                      },
                    ),
                  )
                ],
              ),
            ),
          )
          ]
        )
      )
    );
  }
}
