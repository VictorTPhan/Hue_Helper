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

  double _hueVarianceValue = 100;
  double _saturationVarianceValue = 0;
  double _luminanceVarianceValue = 0; //what is the absolute brightest the palette can be?
  int _paletteSize = 4;
  
  List<HSLColor> palette = List.empty();

  //depending on the palette organization, this will assign them differently
  //assume palette[0] = adjustedColor
  void calculateOtherColors()
  {
    HSLColor referenceColor = HSLColor.fromColor(widget.adjustedColor);
    double luminanceVariance = _luminanceVarianceValue/_paletteSize;
    double hueVariance = _hueVarianceValue/_paletteSize;
    double saturationVariance = _saturationVarianceValue/_paletteSize;

    int halfWay = (_paletteSize/2).round();

    switch(PaletteTypeState.type)
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

        return;
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
        return;
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
        return;
      }
  }

  @override
  Widget build(BuildContext context) {

    HSLColor mainPaletteColor = HSLColor.fromColor(widget.adjustedColor);

    //create a palette with the amount of colors given
    palette = List.filled(_paletteSize, mainPaletteColor);

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
                                    color: ThemeColors.primaryColor,
                                    fontSize: 20,
                                  )),
                              //if analogous palette, expand hue variance
                              if (PaletteTypeState.type == PaletteOrganization.analogous)
                                Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _hueVarianceValue,
                                    min: 90,
                                    max: 180,
                                    label: _hueVarianceValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _hueVarianceValue = value;
                                      });
                                    }
                                ),
                              )
                              else
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
                                    color: ThemeColors.primaryColor,
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _saturationVarianceValue,
                                    min: 0,
                                    max: 1,
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
                                    color: ThemeColors.primaryColor,
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    activeColor: ThemeColors.secondaryColor,
                                    inactiveColor: ThemeColors.fourthColor,
                                    value: _luminanceVarianceValue,
                                    min: 0,
                                    max: 1,
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
                                    color: ThemeColors.primaryColor,
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
                                    color: i.toColor(),
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