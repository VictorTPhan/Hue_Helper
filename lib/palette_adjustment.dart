import 'package:flutter/material.dart';
import 'package:hue_helper/palette_type.dart';

import 'finished_palette.dart';
import 'main.dart';

class PaletteAdjustment extends StatefulWidget {
  const PaletteAdjustment({Key? key, required this.adjustedColor}) : super(key: key);

  final Color adjustedColor;

  @override
  _PaletteAdjustmentState createState() => _PaletteAdjustmentState();
}

class _PaletteAdjustmentState extends State<PaletteAdjustment> {

  double _hueVarianceValue = 0;
  double _saturationVarianceValue = 0;
  double _luminanceVarianceValue = 255; //what is the absolute brightest the palette can be?
  int _paletteSize = 4;
  
  List<Color> palette = List.empty();

  //depending on the palette organization, this will assign them differently
  //assume palette[0] = adjustedColor
  void calculateOtherColors()
  {
    //TODO: find a better way to get this variable because this is a hacky solution
    switch(PaletteTypeState.type)
    {
      case PaletteOrganization.monochromatic:
        double mainColorLuminance = widget.adjustedColor.computeLuminance();

        //TODO: calculate a luminance variance for each color channel. this current method adjusts the hue.
        double luminanceVarianceRed = (_luminanceVarianceValue-widget.adjustedColor.red)/(_paletteSize - 1);
        double luminanceVarianceGreen = (_luminanceVarianceValue-widget.adjustedColor.green)/(_paletteSize - 1);
        double luminanceVarianceBlue = (_luminanceVarianceValue-widget.adjustedColor.blue)/(_paletteSize - 1);

        for (int i = 1; i < _paletteSize; i++) {
          Color c = widget.adjustedColor;
          int r = (c.red + (luminanceVarianceRed * i)).round();
          int g = (c.green + (luminanceVarianceGreen * i)).round();
          int b = (c.blue + (luminanceVarianceBlue * i)).round();

          if (r > 255) r = 255;
          if (g > 255) g = 255;
          if (b > 255) b = 255;

          palette[i] = Color.fromRGBO(r, g, b, 1);
        }
        return;
      case PaletteOrganization.analogous:
        return;
      case PaletteOrganization.complementary:
        for (int i = (_paletteSize/2).round(); i < _paletteSize; i++)
          {
            palette[i] = Colors.red;
          }
        return;
      }
  }

  @override
  Widget build(BuildContext context) {

    //create a palette with the amount of colors given
    palette = List.filled(_paletteSize, widget.adjustedColor);

    //generate a palette
    calculateOtherColors();

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
                        'lets adjust the contrast',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 70,
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
                              Text('how much should the other colors differ in hue?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _hueVarianceValue,
                                    min: 0,
                                    max: 100,
                                    label: _hueVarianceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _hueVarianceValue = value;
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
                              Text('how intense should the other hues be?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _saturationVarianceValue,
                                    min: 0,
                                    max: 100,
                                    label: _saturationVarianceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _saturationVarianceValue = value;
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
                              Text('how bright should the other colors be?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _luminanceVarianceValue,
                                    min: widget.adjustedColor.computeLuminance() * 255,
                                    max: 255,
                                    label: _luminanceVarianceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _luminanceVarianceValue = value;
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
                                child: Text('   Palette Size   ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    )),
                              ),
                              Text('how many colors do you want?',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _paletteSize.toDouble(),
                                    min: 2,
                                    max: 6,
                                    divisions: 4,
                                    label: _paletteSize.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _paletteSize = value.toInt();
                                      });
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(
                  flex: 10,
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
                                    builder: (context) => FinishedPalette(finalPalette: palette,)),
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