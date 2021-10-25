import 'package:flutter/material.dart';
import 'package:hue_helper/palette_type.dart';
import 'basic_widgets.dart';
import 'main.dart';

enum colorType {red, orange, yellow, lime, green, cyan, blue, purple, magenta}
enum paletteType {monochromatic, complementary, analogous, none}
enum paletteRigidity {strong, loose, none} //how much does the palette fit into one of the 3 types?

class PaletteInfo //we will put any information about the palette that we analyze here
{
   PaletteInfo({this.type = paletteType.none, this.rigidity = paletteRigidity.none, this.reason = ''});

   paletteType type;
   paletteRigidity rigidity;
   String reason;
}

class PaletteAnalysis extends StatelessWidget {
  PaletteAnalysis({Key? key, required this.palette, required this.paletteSize}) : super(key: key);

  List<Color> palette;
  final int paletteSize; //if the user inputs a 6 palette, goes back, selects a 4, and then goes forward, it does not cut off the 2 unnecessary colors.

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

  List<int> generateHueDeltas(List<int> averageHues)
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
    return averageHueDeltas;
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

  double calculateTotalHueDeltas(List<int> hueDeltas)
  {
    double totalHueDeltas = 0;
    for (int i in hueDeltas) {
      totalHueDeltas += i;
    }
    return totalHueDeltas;
  }

  int analogousBlunderAnalysis(double totalHueDeltas, List<int> hueDeltas)
  {
    double averageHueVariance = totalHueDeltas/hueDeltas.length;

    //then we'll see if the hue deltas are within __ of the average hue delta.
    int blunders = 0; //we will record any that do not fit into this section
    for (int i in hueDeltas) {
      if (i < averageHueVariance-20 && i > averageHueVariance+20) //does it not fit within 20 of the hue variance?
        blunders++;
    }

    return blunders;
  }

  PaletteInfo hueAnalysis(List<int> averageHues, List<int> hueDeltas)
  {
    PaletteInfo generatedInfo = PaletteInfo();
    double totalHueDeltas = calculateTotalHueDeltas(hueDeltas);
    int blunders = analogousBlunderAnalysis(totalHueDeltas, hueDeltas);

    //if the hue delta is within 40 of 180, then it is a complementary palette
    if (hueDeltas.length == 1 && hueDeltas[0] > 140 && hueDeltas[0] < 220) {
      generatedInfo.type = paletteType.complementary;

      //if within 20 of 180, it is a strong match
      if (hueDeltas[0] > 160 && hueDeltas[0] < 200) {
        generatedInfo.rigidity = paletteRigidity.strong;
        generatedInfo.reason = "Color is a close complement.";
      }
      else {
        generatedInfo.rigidity = paletteRigidity.loose;
        generatedInfo.reason = "Color is not an exact complement.";
      }
    }
    //if there is at most 2 blunders in hue variance, it is analogous.
    else if (blunders <= 2){
      generatedInfo.type = paletteType.analogous;

      //there are two factors in how strong an analogous palette is: how wide the range is, and how consistent the colors are placed.

      if (blunders <= 1) { //how consistent are the colors placed?
        generatedInfo.rigidity = paletteRigidity.strong;
        generatedInfo.reason =
        "There is at most one color with an inconsistent hue variation.";
      }
      else {
        generatedInfo.rigidity = paletteRigidity.loose;
        generatedInfo.reason =
        "There is at least one color with an inconsistent hue variation.";
      }

      if (totalHueDeltas > 200){ //is the range too wide?
        generatedInfo.rigidity = paletteRigidity.loose;
        generatedInfo.reason +=
        " The range of hues is too wide.";
      }
      else{
        generatedInfo.rigidity = paletteRigidity.strong;
        generatedInfo.reason +=
        " The range of hues is well-constrained.";
      }
    }

    print(generatedInfo.type);
    print(generatedInfo.rigidity);
    print(generatedInfo.reason);

    return generatedInfo;
  }

  @override
  Widget build(BuildContext context) {

    //remove any unnecessary colors (see comment on paletteSize)
    palette = palette.sublist(0, paletteSize);

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
    
    List<int> hueDeltas = generateHueDeltas(averageColorHues);
    listAllColors(averageColorHues);

    PaletteInfo info = hueAnalysis(averageColorHues, hueDeltas);

    return Scaffold(
        body: Center(
        child: Column(
        children: [
          createTopText("let's see..."),
          Expanded( //The part that shows the palette
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
          Expanded( //the part that shows the hue variation
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                          left: i/370 * MediaQuery.of(context).size.width,
                          child: Icon(Icons.circle, color: Colors.black),
                      )
                  ],
                ),
              ),
            ),
          ),
          Expanded( //the part that shows the saturation variation
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                        left: i/1.05 * MediaQuery.of(context).size.width,
                        child: Icon(Icons.circle, color: Colors.white),
                      )
                  ],
                ),
              ),
            ),
          ),
          Expanded( //the part that shows the luminance variation
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                        left: i/1.05 * MediaQuery.of(context).size.width,
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
          createBottomRow(Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyApp()),
            );
          }),
          ]
        )
      )
    );
  }
}
