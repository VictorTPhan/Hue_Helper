import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hue_helper/palette_adjustment.dart';
import 'color_data.dart';

class ColorAdjustment extends StatefulWidget {
  const ColorAdjustment({Key? key, required this.givenColor}) : super(key: key);

  final ColorData givenColor;

  @override
  _ColorAdjustmentState createState() => _ColorAdjustmentState();
}

class _ColorAdjustmentState extends State<ColorAdjustment> {

  //based on mathematics from:
  //https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  double _ensureCorrectColorFormula(double temp1, temp2, tempChannel)
  {
    double result = 0;

    if (6 * tempChannel < 1) {
      result = temp2 + (temp1 - temp2) * 6 * tempChannel;
      if (result < 1) {
        //print('test 1 ' + result.toString());
        return result;
      }
    }

    //if first result is bigger than 1, perform second test
    if (2 * tempChannel < 1) {
      result = temp1;
      if (result < 1) {
        //print('test 2 ' + result.toString());
        return result;
      }
    }

    //if second result is bigger than 1, perform third test
    if (3 * tempChannel < 2) {
      result = temp2 + (temp1 - temp2) * (0.666 - tempChannel) * 6;

      if (result < 2) {
        //print('test 3 passed ' + result.toString());
        return result;
      }
    }
    else {
      //print('test 3 failed ' + temp2.toString());
      return temp2;
    }

    //print('all tests failed (invalid)');
    return result;
  }

  //based on mathematics from:
  //https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  int _redGreenBluetoHue(int R,G,B)
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
    hue = hue.roundToDouble();

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
    return hue.toInt();
  }

  //based on mathematics from:
  //https://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  List<int> _hueSaturationValueToRGB(int hue, saturation, luminance)
  {
    //convert ints to percentages
    double lumPercent = luminance / 100;
    double satPercent = saturation / 100;

    //saturation
    double temp1;
    if (luminance < 50) {
      temp1 = (lumPercent * (1 + satPercent));
    } else {
      temp1 = (lumPercent + satPercent - lumPercent * satPercent);
    }

    //print('temp1: ' + temp1.toString());

    double temp2 = 2 * lumPercent - temp1;

    //print('temp2: ' + temp2.toString());

    //hue
    double newHue = hue / 360;
    double tempR;
    double tempG;
    double tempB;

    //print('newHue: ' + newHue.toString());

    tempR = (newHue + 0.333);
    tempG = newHue;
    tempB = newHue - 0.333;

    if (tempR < 0)
      tempR++;
    else if (tempR >= 1) tempR--;
    if (tempG < 0)
      tempG++;
    else if (tempG >= 1) tempG--;
    if (tempB < 0)
      tempB++;
    else if (tempB >= 1) tempB--;

    //print('tempR: ' + tempR.toString());
    //print('tempG: ' + tempG.toString());
    //print('tempB: ' + tempB.toString());

    //3 tests must be done per color channel
    tempR = _ensureCorrectColorFormula(temp1, temp2, tempR);
    tempG = _ensureCorrectColorFormula(temp1, temp2, tempG);
    tempB = _ensureCorrectColorFormula(temp1, temp2, tempB);

    //print('now tempR: ' + tempR.toString());
    //print('now tempG: ' + tempG.toString());
    //print('now tempB: ' + tempB.toString());

    //convert to 8 bit
    int endR = (tempR * 255).round().clamp(0, 255);
    int endG = (tempG * 255).round().clamp(0, 255);
    int endB = (tempB * 255).round().clamp(0, 255);

    //print('final R: ' + endR.toString());
    //print('final G: ' + endG.toString());
    //print('final B: ' + endB.toString());

    return [endR, endG, endB];
  }

  //50% between both hue limiters
  double _currentHueModifierValue = 0;
  double _currentSaturationValue = 100;
  double _currentLuminanceValue = 50;

  @override
  Widget build(BuildContext context) {

    //this is the original color that you chose before. in this screen you will be able to adjust its hue.
    Color selectedColor = widget.givenColor.color;

    //for this to work, the low limit must now be a negative integer,
    //the main color is 0 on the scale between them,
    //and the high limit is a positive integer.
    int _adjustedLowLimit = widget.givenColor.lowLimit;
    int _adjustedHighLimit = widget.givenColor.highLimit;

    //if the low limit is near 360 (like 337) and the high limit is near 0 (like 14),
    //we do some extra math in order to convert the low into a negative integer (in that example, -23).
    if (widget.givenColor.highLimit < widget.givenColor.lowLimit){
      _adjustedLowLimit=widget.givenColor.lowLimit-360;
    }

    //now the low limit is under 0 and the high limit is over 0.
    int _mainColorHue = _redGreenBluetoHue(
        selectedColor.red,
        selectedColor.green,
        selectedColor.blue);
    _adjustedLowLimit-=_mainColorHue;
    _adjustedHighLimit-=_mainColorHue;

    //the actual amount of hue to adjust
    int _hueModifier = 0;
    if (_currentHueModifierValue < 0){
      _hueModifier = -((_currentHueModifierValue/100) * _adjustedLowLimit).round();
    }
    else if (_currentHueModifierValue > 0){
      _hueModifier = ((_currentHueModifierValue/100) * _adjustedHighLimit).round();
    }

    //records any new color
    List<int> changedValues;

    //the main hue of the color, plus additional hue modifiers.
    int _selectedColorHue = _mainColorHue + _hueModifier.round();

    //the color hue must be between 0 and 360. Any overlap is thus corrected.
    if (_selectedColorHue < 0) _selectedColorHue+=360;
    else if (_selectedColorHue > 360) _selectedColorHue -= 360;

      changedValues = _hueSaturationValueToRGB(
          _selectedColorHue,
          _currentSaturationValue,
          _currentLuminanceValue);
      selectedColor = new Color.fromRGBO(changedValues[0], changedValues[1], changedValues[2], 1);

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
                              Text('Hue',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how much should the other hue differ?',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    value: _currentHueModifierValue,
                                    min: -100,
                                    max: 100,
                                    label: _hueModifier.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentHueModifierValue = value;
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
                                    label: _currentSaturationValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSaturationValue = value;
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
                                    label: _currentLuminanceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentLuminanceValue = value;
                                      });
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.all(8.0),
                              color: selectedColor,
                              child: Text(
                                  _selectedColorHue.toString() + ', ' +
                                  _currentSaturationValue.toString() + ', ' +
                                  _currentLuminanceValue.toString()
                          )),
                        )
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
                                          PaletteAdjustment())
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
