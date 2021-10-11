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
  double _luminanceVarianceValue = 0.5; //what is the absolute brightest the palette can be?
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

    //TODO: find a better way to get this variable because this is a hacky solution
    switch(PaletteTypeState.type)
    {
      case PaletteOrganization.monochromatic:
        for (int i = 0; i<(_paletteSize/2).round(); i++)
        {
          double lumDelta = referenceColor.lightness + (luminanceVariance*2) * i;
          if (lumDelta < 0) lumDelta=0;
          if (lumDelta > 1) lumDelta=1;
          palette[i] = referenceColor.withLightness(lumDelta);
        }
        for (int i = (_paletteSize/2).round(); i<_paletteSize; i++)
        {
          //the +1 at the end is so that the dark colors don't start at the main color luminance
          double lumDelta = referenceColor.lightness - (luminanceVariance) * (i-(_paletteSize/2).round()+1);
          if (lumDelta < 0) lumDelta=0;
          if (lumDelta > 1) lumDelta=1;
          palette[i] = referenceColor.withLightness(lumDelta);
        }
        return;
      case PaletteOrganization.analogous:
        for (int i = 0; i<_paletteSize; i++)
          {
            double lumDelta = (0.5 + luminanceVariance * i);
            if (lumDelta < 0) lumDelta=0;
            if (lumDelta > 1) lumDelta=1;
            palette[i] = referenceColor.withLightness(lumDelta);
            palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVariance * i).clamp(0, 1));

            double hueDelta = referenceColor.hue + hueVariance * i;
            if (hueDelta < 0) hueDelta+=360;
            if (hueDelta > 360) hueDelta-=360;
            palette[i] = palette[i].withHue(hueDelta);
          }
        return;
      case PaletteOrganization.complementary:
        double saturationVarianceComplementary = _saturationVarianceValue/(_paletteSize/2).round();
        double oppositeHue = (180-referenceColor.hue).abs();

        for (int i = 0; i< (_paletteSize/2).round(); i++)
          {
            palette[i] = referenceColor.withLightness((0.5 + luminanceVariance * i).clamp(0, 1));

            double hueDelta = referenceColor.hue + hueVariance * i;
            if (hueDelta < 0) hueDelta+=360;
            if (hueDelta > 360) hueDelta-=360;
            palette[i] = palette[i].withHue(hueDelta);

            palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVarianceComplementary * i).clamp(0, 1));
          }

        palette[_paletteSize-1] = referenceColor.withHue(oppositeHue);

        for (int i = (_paletteSize/2).round(); i< _paletteSize; i++)
        {
          palette[i] = palette[i].withLightness((0.5 + luminanceVariance * (i-(_paletteSize/2).round())).clamp(0, 1));

          double hueDelta = (oppositeHue - hueVariance * (i-(_paletteSize/2).round()));
          if (hueDelta < 0) hueDelta+=360;
          if (hueDelta > 360) hueDelta-=360;
          palette[i] = palette[i].withHue(hueDelta);

          palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVarianceComplementary * (i-(_paletteSize/2).round())).clamp(0, 1));
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