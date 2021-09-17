import 'dart:math';

import 'package:flutter/material.dart';

class ColorAdjustment extends StatefulWidget {
  const ColorAdjustment({Key? key}) : super(key: key);

  @override
  _ColorAdjustmentState createState() => _ColorAdjustmentState();
}

class _ColorAdjustmentState extends State<ColorAdjustment> {

  Color selectedColor = Colors.red;
  int counter = 0;

  //based on mathematics from:
  //https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  double _ensureCorrectColorFormula(double temp1, temp2, tempChannel)
  {
    if (6 * tempChannel < 1)
        tempChannel = temp2 + (temp1-temp2) * 6 * tempChannel;
    else if (2 * tempChannel < 1)
      tempChannel = temp1;
    else if (3 * tempChannel < 2)
      tempChannel = temp2 + (temp1-temp2) * (0.666 - tempChannel) * 6;
    else tempChannel = temp2;

    return tempChannel;
  }

  //based on mathematics from:
  //https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  int _RBGtoHue(int R,G,B)
  {
    //convert RBG values to range 0-1
    double tempR = R/255;
    double tempG = G/255;
    double tempB = B/255;

    //clamp between 0 and 1
    tempR.clamp(0, 1);
    tempG.clamp(0, 1);
    tempB.clamp(0, 1);

    //determine which is the lowest channel
    double minValue = min(min(tempR, tempG), tempB);

    //determine which is the highest channel
    //which channel is the highest must be recorded
    double maxValue = 0;
    int channel = 0;
    if (tempR > tempG && tempR > tempB) maxValue = tempR;
    else if (tempG > tempR && tempG > tempB) {maxValue = tempG; channel = 1; }
    else if (tempB > tempG && tempB > tempR) {maxValue = tempB; channel = 2; }

    //hue depends on which channel is the largest
    double hue = 0;
    if (channel == 0) hue = ((tempG-tempB)/(maxValue-minValue));
    else if (channel == 1) hue = (2 + (tempB-tempR)/(maxValue-minValue));
    else if (channel == 2) hue = (4 + (tempR-tempG)/(maxValue-minValue));

    //now convert hue to degrees
    hue*=60;
    if (hue < 0) hue+=360;

    /*
    print('R: ' + tempR.toString());
    print('G: ' + tempG.toString());
    print('B: ' + tempB.toString());
    print('hue: ' + hue.toString());
    print('minValue: ' + minValue.toString());
    print('maxValue: ' + maxValue.toString());
    print((tempG-tempB).toString());
    print((maxValue-minValue).toString());
    print('channel: ' + channel.toString());
    */

    //round to integer
    return hue.round();
  }

  //based on mathematics from:
  //https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  void _HSLtoRGB(int hue, saturation, luminance)
  {
    setState(() {
      //will represent R, G, B channels, 0 to 255
      int R;
      int G;
      int B;

      //take luminance as a percentage and set all RBG values to 255 * luminance%
      double lumPercent = luminance/100;
      R = (lumPercent * 255).round();
      G = R;
      B = G;

      //saturation
      double temp1;
      if (luminance < 50){
        temp1 = (luminance * (1+saturation)) as double;
      }
      else {
        temp1 = (luminance + saturation - luminance * saturation) as double;
      }

      double temp2 = 2 * luminance - temp1;

      //hue
      double newHue = hue / 360;
      double tempR;
      double tempG;
      double tempB;

      tempR = (newHue + 0.333);
      tempG = newHue;
      tempB = newHue - 0.333;

      tempR.clamp(0, 1);
      tempG.clamp(0, 1);
      tempB.clamp(0, 1);

      //3 tests must be done per color channel
      tempR = _ensureCorrectColorFormula(temp1, temp2, tempR);
      tempR = _ensureCorrectColorFormula(temp1, temp2, tempG);
      tempR = _ensureCorrectColorFormula(temp1, temp2, tempB);

      //convert to 8 bit
      int endR = (tempR*255).round();
      int endG = (tempG*255).round();
      int endB = (tempB*255).round();

      selectedColor.withRed(endR);
      selectedColor.withGreen(endG);
      selectedColor.withBlue(endB);

      print(selectedColor.red);
      counter++;
    });
  }

  double _currentHueVarianceValue = 50;
  double _currentSaturationValue = 100;
  double _currentLuminanceValue = 100;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        'lets adjust the color a bit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Column(
                            children: [
                              Text('Hue Variance',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how much should the other hues differ?',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    value: _currentHueVarianceValue,
                                    min: 0,
                                    max: 100,
                                    divisions: 4,
                                    label: _currentHueVarianceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentHueVarianceValue = value;

                                      });
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Column(
                            children: [
                              Text('Saturation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how intense is the hue?',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    value: _currentSaturationValue,
                                    min: 0,
                                    max: 100,
                                    divisions: 4,
                                    label: _currentSaturationValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSaturationValue = value;
                                        _HSLtoRGB(
                                            _RBGtoHue(
                                                selectedColor.red,
                                                selectedColor.green,
                                                selectedColor.blue),
                                            _currentSaturationValue,
                                            _currentLuminanceValue);
                                      });
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Column(
                            children: [
                              Text('Luminance',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how bright is the color?',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    value: _currentLuminanceValue,
                                    min: 0,
                                    max: 100,
                                    divisions: 4,
                                    label: _currentLuminanceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentLuminanceValue = value;
                                        _HSLtoRGB(
                                            _RBGtoHue(
                                                selectedColor.red,
                                                selectedColor.green,
                                                selectedColor.blue),
                                            _currentSaturationValue,
                                            _currentLuminanceValue);
                                      });
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(color: selectedColor, child: Text(counter.toString()))
                      ],
                    )
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ColorAdjustment())
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
