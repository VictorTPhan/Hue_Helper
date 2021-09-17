import 'package:flutter/material.dart';

class ColorAdjustment extends StatefulWidget {
  const ColorAdjustment({Key? key}) : super(key: key);

  @override
  _ColorAdjustmentState createState() => _ColorAdjustmentState();
}

class _ColorAdjustmentState extends State<ColorAdjustment> {

  final Color selectedColor = Colors.red;

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
                              Text('how much should the hue differ?',
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
                              Text('Lumiance',
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
                                      });
                                    }
                                ),
                              )
                            ],
                          ),
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
