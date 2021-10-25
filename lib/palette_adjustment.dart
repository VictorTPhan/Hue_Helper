import 'package:flutter/material.dart';
import 'package:hue_helper/basic_widgets.dart';
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

  double _hueVarianceValue = 90;
  double _saturationVarianceValue = 0;
  double _luminanceVarianceValue = 0; //what is the absolute brightest the palette can be?
  int _paletteSize = 4;
  
  List<HSLColor> palette = List.empty();

  //depending on the palette organization, this will assign them differently
  //assume palette[0] = adjustedColor
  void calculateOtherColors()
  {
    HSLColor referenceColor = HSLColor.fromColor(widget.adjustedColor);
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

    double hueMin, hueMax;
    if (PaletteTypeState.type == PaletteOrganization.analogous) {hueMin = 90.0; hueMax = 180.0;}
    else {hueMin = 0; hueMax = 90.0;}

    return Scaffold(
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                createTopText("let's diversify our colors"),
                Expanded(
                    flex: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        createSlider(_hueVarianceValue, 'Hue', 'how different should hues be?', hueMin, hueMax, (double value)
                        { setState(() { _hueVarianceValue = value; }); return setState; }),

                        createSlider(_saturationVarianceValue, 'Saturation', 'how denser should the hues get?', 0, 1, (double value)
                        { setState(() { _saturationVarianceValue = value; }); return setState; }),

                        createSlider(_luminanceVarianceValue, 'Luminance', 'how brighter should the hues get?', 0, 1, (double value)
                        { setState(() { _luminanceVarianceValue = value; }); return setState; }),

                        createSlider(_paletteSize.toDouble(), 'Palette Size', 'how big should your palette be?', 2, 6, (double value)
                        { setState(() { _paletteSize = value.toInt(); }); return setState; }),
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
                createBottomRow(Icons.arrow_forward, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinishedPalette(finalPalette: palette)),
                  );
                }),
              ],
            )));
  }
}