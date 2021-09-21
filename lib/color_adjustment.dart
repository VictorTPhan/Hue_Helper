import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hue_helper/palette_adjustment.dart';
import 'color_data.dart';
import 'main.dart';

class ColorAdjustment extends StatefulWidget {
  const ColorAdjustment({Key? key, required this.givenColor}) : super(key: key);

  final ColorData givenColor;

  @override
  _ColorAdjustmentState createState() => _ColorAdjustmentState();
}

class _ColorAdjustmentState extends State<ColorAdjustment> {

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

  //50% between both hue limiters
  double _currentHueModifierValue = 0;
  double _currentSaturationValue = 1;
  double _currentLuminanceValue = 0.5;

  @override
  Widget build(BuildContext context) {

    //this is the original color that you chose before. in this screen you will be able to adjust its hue.
    HSLColor selectedColor = HSLColor.fromColor(widget.givenColor.color);


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
        widget.givenColor.color.red,
        widget.givenColor.color.green,
        widget.givenColor.color.blue,
    );
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

    //the main hue of the color, plus additional hue modifiers.
    int _selectedColorHue = _mainColorHue + _hueModifier.round();

    //the color hue must be between 0 and 360. Any overlap is thus corrected.
    if (_selectedColorHue < 0) _selectedColorHue+=360;
    else if (_selectedColorHue > 360) _selectedColorHue -= 360;

    selectedColor = selectedColor.withHue(_selectedColorHue.toDouble());
    selectedColor = selectedColor.withSaturation(_currentSaturationValue);
    selectedColor = selectedColor.withLightness(_currentLuminanceValue);

    return Scaffold(
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      color: ThemeColors.primaryColor,
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
                              Container(
                                decoration: BoxDecoration(
                                    color: ThemeColors.secondaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(30))),
                                child: Text('          Hue          ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    )),
                              ),
                              Text('how much should the hue differ?',
                                  style: TextStyle(
                                    color: ThemeColors.primaryColor,
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
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
                              Container(
                                decoration: BoxDecoration(
                                    color: ThemeColors.tertiaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(30))),
                                child: Text('   Saturation    ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    )),
                              ),
                              Text('how intense is the hue?',
                                  style: TextStyle(
                                    color: ThemeColors.primaryColor,
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _currentSaturationValue,
                                    min: 0,
                                    max: 1,
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
                              Container(
                                decoration: BoxDecoration(
                                    color: ThemeColors.fourthColor,
                                    borderRadius: BorderRadius.all(Radius.circular(30))),
                                child: Text('   Luminance   ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    )),
                              ),
                              Text('how bright is the color?',
                                  style: TextStyle(
                                    color: ThemeColors.primaryColor,
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _currentLuminanceValue,
                                    min: 0,
                                    max: 1,
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
                              decoration: BoxDecoration(
                                  color: selectedColor.toColor(),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              margin: EdgeInsets.all(15),
                              ),
                        )
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaletteAdjustment(adjustedColor: selectedColor.toColor())),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
