import 'package:flutter/material.dart';
import 'basic_widgets.dart';
import 'main.dart';

enum colorType {red, orange, yellow, lime, green, cyan, blue, purple, magenta, black, gray, white}
enum paletteType {monochromatic, complementary, analogous, none}
enum paletteRigidity {strong, loose, none} //how much does the palette fit into one of the 3 types?
enum luminanceContrast {strong, solid, weak}
enum luminanceVariance {consistent, inconsistent} //how evenly spaced are luminance values?
enum saturationContrast {strong, solid, weak}
enum saturationVariance {consistent, inconsistent} //how evenly spaced are the saturation values?

class PaletteInfo //we will put any information about the palette that we analyze here
{
   PaletteInfo({this.type = paletteType.none, this.rigidity = paletteRigidity.none, this.reason = ''});

   paletteType type;
   paletteRigidity rigidity;
   String reason;

   String getTypeString()
   {
     switch(type){
       case paletteType.analogous: return "analogous";
       case paletteType.complementary: return "complementary";
       case paletteType.monochromatic: return "monochromatic";
       case paletteType.none: return "not harmonious";
     }
   }

   String getRigidityString()
   {
     switch (rigidity){
       case paletteRigidity.strong: return "strongly";
       case paletteRigidity.loose: return "loosely";
       case paletteRigidity.none: return "";
     }
   }
}

class ContrastInfo
{
    ContrastInfo({this.lumContrast = luminanceContrast.weak, this.lumVariance = luminanceVariance.inconsistent, this.reason = ''});

    luminanceContrast lumContrast;
    luminanceVariance lumVariance;
    String reason;

    String getLuminanceContrastString()
    {
      switch (lumContrast){
        case luminanceContrast.solid: return "solid";
        case luminanceContrast.weak: return "weak";
        case luminanceContrast.strong: return "strong";
      }
    }

    String getLuminanceVarianceString()
    {
      switch (lumVariance){
        case luminanceVariance.consistent: return "consistent";
        case luminanceVariance.inconsistent: return "uneven";
      }
    }
}

class SaturationInfo
{
  SaturationInfo({this.satContrast = luminanceContrast.weak, this.satVariance = luminanceVariance.inconsistent, this.reason = ''});

  luminanceContrast satContrast;
  luminanceVariance satVariance;
  String reason;

  String getSaturationContrastString()
  {
    switch (satContrast){
      case luminanceContrast.solid: return "solid";
      case luminanceContrast.weak: return "weak";
      case luminanceContrast.strong: return "strong";
    }
  }

  String getSaturationVarianceString()
  {
    switch (satVariance){
      case luminanceVariance.consistent: return "consistent";
      case luminanceVariance.inconsistent: return "uneven";
    }
  }
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

  String getStringFromColor(colorType type)
  {
    switch(type){
      case (colorType.red): return "red";
      case (colorType.orange): return "orange";
      case (colorType.yellow): return "yellow";
      case (colorType.lime): return "lime";
      case (colorType.green): return "green";
      case (colorType.cyan): return "cyan";
      case (colorType.blue): return "blue";
      case (colorType.purple): return "purple";
      case (colorType.magenta): return "magenta";
      default: return ''; //this should never occur
    }
  }

  //assume the color going in has no saturation
  colorType getMonotoneColor(HSLColor c)
  {
    if (c.lightness == 0) return colorType.black;
    else if (c.lightness == 1) return colorType.white;
    else return colorType.gray;
  }

  //assume the color after lastColor is indeed monotone
  bool wasLastColorMonochromatic(double saturationOfLastColor)
  {
    return (saturationOfLastColor != 0)? false: true;
  }

  bool warrantsNewColor(int hueValue, double saturationValue, int lastColorValue)
  {
    if (saturationValue == 0) return false;

    //what color was the last value?, and does this value fall within that range?
    return (getColorFromHue(lastColorValue) == getColorFromHue(hueValue))? false: true;
  }

  //assume all of these are sorted according to hue and have the same length
  List<List<int>> generateHueMatrix(List<int> hues, List<double> saturations, List<double> lightness)
  {
    //var colorMatrix = new List.generate(amountOfColors, (_) => new List.filled(6, 0, growable: false));
    var colorMatrix = new List.generate(1, (_) => new List.filled(0, 0, growable: true), growable: true);

    //determines where the colors start
    int currentColorIndex = 0;

    //start off by adding first value to [0][0]
    colorMatrix[0].add(hues[0]);

    for(int i = 1; i<hues.length; i++)
    {
      //is this color different from the last one, and is it a color?
        if (warrantsNewColor(hues[i], saturations[i], hues[i-1]))
        {
          currentColorIndex++;

          //add a new list (this represents a new color)
          colorMatrix.add(new List.filled(0, 0, growable: true));

          //add the value to the current color
          colorMatrix[currentColorIndex].add(hues[i]);
        }
    }

    if (colorMatrix[0][0] == 0 && saturations[0] == 0) colorMatrix.removeAt(0);

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

    print("Average Hue Deltas:" + averageHueDeltas.toString());
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
      if (i.length == 1) //if there is only 1 value then any other calculations are unnecessary
        averageColorHues.add(i[0]);
      //for specifically red, whose values start at the end of the spectrum and end at the start of it, you need to do something special
      else if (getColorFromHue(i[0]) == colorType.red) {
        int total = 0;
        for (int j in i){
          if (j<=360) j-=360; //is the color value at the end of the spectrum? If so, correct it.
          total+=j;
        }

        averageColorHues.add(total~/i.length);
      }
      else { //otherwise, get the average value of all the other colors
        int total = 0;
        for(int j in i) total+=j;

        averageColorHues.add(total~/i.length);
      }
    }

    print("Average Color Hues: " + averageColorHues.toString());
    
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

  List<double> generateLuminanceDeltas(List<double> luminances)
  {
    //represents the distance between average hues in colors
    List<double> luminanceDeltas = List.filled(luminances.length-1, 0);

    //get the hue variance between each color
    for(int i = 0; i<luminanceDeltas.length; i++)
    {
      double lumDelta = luminances[i+1]-luminances[i];
      luminanceDeltas[i] = lumDelta;
    }

    return luminanceDeltas;
  }

  List<double> generateSaturationDeltas(List<double> saturations)
  {
    //represents the distance between average hues in colors
    List<double> saturationDeltas = List.filled(saturations.length-1, 0);

    //get the hue variance between each color
    for(int i = 0; i<saturationDeltas.length; i++)
    {
      double lumDelta = saturations[i+1]-saturations[i];
      saturationDeltas[i] = lumDelta;
    }

    return saturationDeltas;
  }

  PaletteInfo hueAnalysis(List<List<int>> matrix, List<int> averageHues, List<int> hueDeltas)
  {
    PaletteInfo generatedInfo = PaletteInfo();
    double totalHueDeltas = calculateTotalHueDeltas(hueDeltas);
    int blunders = analogousBlunderAnalysis(totalHueDeltas, hueDeltas);

    //if it's only one color, it's monochromatic
    if (matrix.length == 1){
      generatedInfo.type = paletteType.monochromatic;

      generatedInfo.rigidity = paletteRigidity.strong;
      generatedInfo.reason = "All colors belong to the same general hue.";
    }
    //if the hue delta is within 40 of 180, then it is a complementary palette
    else if (hueDeltas.length == 1 && hueDeltas[0] > 140 && hueDeltas[0] < 220) {
      generatedInfo.type = paletteType.complementary;

      //if within 20 of 180, it is a strong match
      if (hueDeltas[0] > 160 && hueDeltas[0] < 200) {
        generatedInfo.rigidity = paletteRigidity.strong;
        generatedInfo.reason = "The opposing color is a close complement.";
      }
      else {
        generatedInfo.rigidity = paletteRigidity.loose;
        generatedInfo.reason = "The opposing color is not an exact complement.";

        //what should the actual complement color be?
        int oppositeHue = averageHues[0] + 180;
        if (oppositeHue > 360) oppositeHue-=360;

        generatedInfo.reason += " Consider shifting those hues to a more " + getStringFromColor(getColorFromHue(oppositeHue)) + " hue.";
      }
    }
    //if there is at most 2 blunders in hue variance and the color range is not very large, it is analogous.
    //let the color range be arbitrary.
    else if (blunders <= 2 && averageHues[averageHues.length-1]-averageHues[0]<120){
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
    else{
      generatedInfo.type = paletteType.none;
      generatedInfo.rigidity = paletteRigidity.none;
      generatedInfo.reason = "There might be one or more rogue colors.";
    }

    return generatedInfo;
  }

  int calculateLuminanceBlunders(List<double> luminanceDeltas, double targetDelta)
  {
    int blunders = 0;
    for (double i in luminanceDeltas)
      {
        //we will compare the value to the average luminance value and use an arbitrary percentage range.
        if (i < targetDelta*0.9 || i > targetDelta*1.1){
          blunders++;
        }
      }
    return blunders;
  }

  //assume luminances is sorted.
  ContrastInfo luminanceAnalysis(List<double> luminances, List<double> luminanceDeltas)
  {
    ContrastInfo generatedInfo = ContrastInfo();
    double targetVariation = (luminances.last - luminances.first)/luminances.length;
    print("Luminance Deltas:" + luminanceDeltas.toString());

      //how far is the contrast for the two colors?
      //cache these values
      double difference = luminances.last - luminances.first;

      if (difference > 0.75) //too strong!
        generatedInfo.lumContrast = luminanceContrast.strong;
      else if (difference > 0.25) //acceptable
        generatedInfo.lumContrast = luminanceContrast.solid;
      else generatedInfo.lumContrast = luminanceContrast.weak; //too weak!

      //we are now going to see how evenly spaced these values are. This is the luminance variance part of our info.
      //we don't need to do loops for just 2 colors.
      if (luminanceDeltas.length>1){
        int blunders = calculateLuminanceBlunders(luminanceDeltas, targetVariation);
        if (blunders < 1) generatedInfo.lumVariance = luminanceVariance.consistent;
        else {
          generatedInfo.lumVariance = luminanceVariance.inconsistent;
          generatedInfo.reason = "There is at least one outlier in luminance.";
        }
      }
      else{
        generatedInfo.lumVariance = luminanceVariance.consistent;
        generatedInfo.reason = "There are only two luminance values.";
      }

      return generatedInfo;
  }

  //assume luminances is sorted.
  SaturationInfo saturationAnalysis(List<double> saturations, List<double> saturationDeltas)
  {
    SaturationInfo generatedInfo = SaturationInfo();
    double targetVariation = (saturations.last - saturations.first)/saturations.length;
    print("Saturation Deltas:" + saturationDeltas.toString());

    //how far is the contrast for the two colors?
    //cache these values
    double difference = saturations.last - saturations.first;

    if (difference > 0.75) //too strong!
      generatedInfo.satContrast = luminanceContrast.strong;
    else if (difference > 0.25) //acceptable
      generatedInfo.satContrast = luminanceContrast.solid;
    else generatedInfo.satContrast = luminanceContrast.weak; //too weak!

    //we are now going to see how evenly spaced these values are. This is the luminance variance part of our info.
    //we don't need to do loops for just 2 colors.
    if (saturationDeltas.length>1){
      int blunders = calculateLuminanceBlunders(saturationDeltas, targetVariation);
      if (blunders < 1) generatedInfo.satVariance = luminanceVariance.consistent;
      else {
        generatedInfo.satVariance = luminanceVariance.inconsistent;
        generatedInfo.reason = "There is at least one outlier in saturation.";
      }
    }
    else{
      generatedInfo.satVariance = luminanceVariance.consistent;
      generatedInfo.reason = "There are only two saturation values.";
    }

    return generatedInfo;
  }

  //uses selection sort
  //assume the lengths of all parameters are the same.
  List<int> sortAccordingtoHue(List<int> hue, List<double> saturation, List<double> luminance){
    for (int currentIndexToSwitch = 0; currentIndexToSwitch < hue.length; currentIndexToSwitch++){
      //find the smallest element in the array
      int indexOfMin = currentIndexToSwitch;
      int minimum = hue[indexOfMin];
      for (int i = indexOfMin; i<hue.length; i++){
        if (hue[i] <= minimum) {
          indexOfMin = i;
          minimum = hue[i];
        }
      }

      //exchange the smallest element with the one at the first position.
      int temp1 = hue[indexOfMin];
      hue[indexOfMin] = hue[currentIndexToSwitch];
      hue[currentIndexToSwitch] = temp1;

      //do the same for the other lists.
      double temp2 = saturation[indexOfMin];
      saturation[indexOfMin] = saturation[currentIndexToSwitch];
      saturation[currentIndexToSwitch] = temp2;

      //for some reason black is labelled as very saturated (?) so we correct that.
      if (saturation[currentIndexToSwitch] == 1 && luminance[currentIndexToSwitch] == 0)
        saturation[currentIndexToSwitch] = 0;

      double temp3 = luminance[indexOfMin];
      luminance[indexOfMin] = luminance[currentIndexToSwitch];
      luminance[currentIndexToSwitch] = temp3;
    }

    return hue;
  }

  //assume all lists have the same length
  List<int> removeMonochromeColors(List<int> hue, List<double> saturation) {

    List<double> tempSaturation = List.from(saturation);

    for (int i = 0; i<hue.length; i++){
      if (tempSaturation[i] == 0) {
        hue.removeAt(i);
        tempSaturation.removeAt(i);
        i--;
      }
    }
    return hue;
  }

  @override
  Widget build(BuildContext context) {

    //remove any unnecessary colors (see comment on paletteSize)
    palette = palette.sublist(0, paletteSize);

    List<int> hueValues = List.filled(0, 0, growable: true);
    List<double> saturationValues = List.filled(0, 0, growable: true);
    List<double> lightnessValues = List.filled(0, 0, growable: true);

    //save all values into hueValues
    for (Color c in palette){
      hueValues.add(HSLColor.fromColor(c).hue.toInt());
      saturationValues.add(HSLColor.fromColor(c).saturation.toDouble());
      lightnessValues.add(HSLColor.fromColor(c).lightness.toDouble());
    }

    sortAccordingtoHue(hueValues, saturationValues, lightnessValues);

    print("Hues " + hueValues.toString());
    print("Saturations " + saturationValues.toString());
    print("Luminances " + lightnessValues.toString());

    List<List<int>> matrix = generateHueMatrix(hueValues, saturationValues, lightnessValues);
    List<int> averageColorHues = getAverageColors(matrix);
    List<double> luminanceDeltas = generateLuminanceDeltas(lightnessValues);
    List<double> saturationDeltas = generateSaturationDeltas(saturationValues);
    
    List<int> hueDeltas = generateHueDeltas(averageColorHues);

    removeMonochromeColors(hueValues, saturationValues);
    hueValues.sort();
    PaletteInfo pInfo = hueAnalysis(matrix, averageColorHues, hueDeltas);

    lightnessValues.sort();
    saturationValues.sort();
    ContrastInfo cInfo = luminanceAnalysis(lightnessValues, luminanceDeltas);
    SaturationInfo sInfo = saturationAnalysis(saturationValues, saturationDeltas);

    return Scaffold(
        body: Center(
        child: Column(
        children: [
          createTopText("let's see..."),
          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.only(left: 3.0, right: 3.0, top:5.0),
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
          ), //The part that shows the palette
          Expanded(
            flex: 5,
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
          ), //the part that shows the hue variation
          Expanded(
            flex: 5,
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
          ), //the part that shows the saturation variation
          Expanded(
            flex: 5,
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
          ), //the part that shows the luminance variation
          Expanded(
              flex: 55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("The palette type is " + pInfo.getRigidityString() + " " + pInfo.getTypeString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(pInfo.reason.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 20,)),
                  Text("The luminance contrast is " + cInfo.getLuminanceContrastString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("The distribution for luminance values is " + cInfo.getLuminanceVarianceString() + ". " + cInfo.reason, textAlign: TextAlign.center, style: TextStyle(fontSize: 20,)),
                  Text("The saturation contrast is " + sInfo.getSaturationContrastString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("The distribution for saturation values is " + sInfo.getSaturationVarianceString() + ". " + sInfo.reason, textAlign: TextAlign.center, style: TextStyle(fontSize: 20,)),
                ],
              )
          ),
          createBottomRow(Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: '')),
            );
          }),
          ]
        )
      )
    );
  }
}
