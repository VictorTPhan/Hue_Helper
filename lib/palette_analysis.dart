import 'package:flutter/material.dart';
import 'main.dart';

enum colorType {red, orange, yellow, lime, green, cyan, blue, purple, magenta}
enum paletteType {monochromatic, complementary, analogous, none}

class PaletteAnalysis extends StatelessWidget {
  const PaletteAnalysis({Key? key, required this.palette}) : super(key: key);

  final List<Color> palette;

  colorType getColorFromHue(int val)
  {
    return (val > 337 || val < 14)? colorType.red:
    (val < 41)? colorType.orange:
    (val < 71)? colorType.yellow:
    (val < 99)? colorType.lime:
    (val < 151)? colorType.green:
    (val < 207)? colorType.cyan:
    (val < 257)? colorType.blue:
    (val < 292)? colorType.purple:
    (val < 336)? colorType.magenta: colorType.magenta;
  }

  bool warrantsNewColor(int hueValue, int lastColorValue)
  {
    //what color was the last value?, and does this value fall within that range?
    return (getColorFromHue(lastColorValue) == getColorFromHue(hueValue))? false: true;
  }

  List<List<int>> generateHueMatrix(List<int> values)
  {
    //sort values from lowest to highest
    values.sort();

    //var colorMatrix = new List.generate(amountOfColors, (_) => new List.filled(6, 0, growable: false));
    var colorMatrix = new List.generate(1, (_) => new List.filled(0, 0, growable: true), growable: true);

    //determines where the colors start
    int currentColorIndex = 0;

    //start off by adding first value to [0][0]
    colorMatrix[0].add(values[0]);

    for(int i = 1; i<values.length; i++)
    {
      //if the next value goes over a certain threshold
      if (warrantsNewColor(values[i], values[i-1]))
      {
        currentColorIndex++;

        //add a new list (this represents a new color)
        colorMatrix.add(new List.filled(0, 0, growable: true));
      }

      //add the value to the current color
      colorMatrix[currentColorIndex].add(values[i]);
    }

    print("colorMatrix: " + colorMatrix.toString());
    return colorMatrix;
  }
  
  void hueAnalysis(List<int> averageHues)
  {
    //represents the distance between average hues in colors
    List<int> averageHueDeltas = List.filled(averageHues.length-1, 0);

    //get the hue variance between each color
    for(int i = 0; i<averageHues.length-1; i++)
    {
      int hueDelta = averageHues[i+1]-averageHues[i];
      averageHueDeltas[i] = hueDelta;
    }

    print(averageHueDeltas.toString());
  }

  void listAllColors(List<int> values)
  {
    for(int val in values)
    {
      print (getColorFromHue(val));
    }
  }

  List<colorType> huesAsColorTypes(List<List<int>> matrix)
  {
    List<colorType> list = List.filled(0, colorType.red, growable: true);

    for(var i in matrix)
    {
      for(var j in i)
        {
          list.add(getColorFromHue(j));
        }
    }

    return list;
  }

  List<int> getAverageColors(List<List<int>> matrix)
  {
    //get the average hue of each color
    List<int> averageColorHues = List.filled(0, 0, growable: true);

    for(var i in matrix)
    {
      if (i.length == 1)
        averageColorHues.add(i[0]);
      else {
        int total = 0;
        for(int j in i) total+=j;

        averageColorHues.add(total~/i.length);
      }
    }

    print(averageColorHues.toString());
    
    return averageColorHues;
  }

  @override
  Widget build(BuildContext context) {

    List<int> hueValues = List.filled(palette.length, 0);
    List<double> saturationValues = List.filled(palette.length, 0);
    List<double> lightnessValues = List.filled(palette.length, 0);

    //save all values into hueValues
    for(int i = 0; i<palette.length; i++)
      {
        hueValues[i] = HSLColor.fromColor(palette[i]).hue.toInt();
        saturationValues[i] = HSLColor.fromColor(palette[i]).saturation.toDouble();
        lightnessValues[i] = HSLColor.fromColor(palette[i]).lightness.toDouble();

        print((saturationValues[i]*100).toInt().toString());
        print((lightnessValues[i]*100).toInt().toString());
        print("      ");
      }

    List<List<int>> matrix = generateHueMatrix(hueValues);
    List<int> averageColorHues = getAverageColors(matrix);
    List<colorType> valuesAsColors = huesAsColorTypes(matrix);
    
    hueAnalysis(averageColorHues);
    listAllColors(averageColorHues);

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                          child: Icon(Icons.circle, color: Colors.black),
                      )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFA8A8A8),
                        Color(0xFE0056FF),
                      ]
                    )
                ),
                child: Stack(
                  children: [
                    for (var i in saturationValues)
                      Positioned(
                        left: i/1.0 * MediaQuery.of(context).size.width,
                        child: Icon(Icons.circle, color: Colors.white),
                      )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF000000),
                          Color(0xFEFFFFFF),
                        ]
                    )
                ),
                child: Stack(
                  children: [
                    for (var i in lightnessValues)
                      Positioned(
                        left: i/1.0 * MediaQuery.of(context).size.width,
                        child:
                          //Text(i.toString())
                          Icon(Icons.circle, color: Colors.red),
                      )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 40,
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
