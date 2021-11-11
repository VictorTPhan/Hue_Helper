import 'package:flutter/material.dart';
import 'package:hue_helper/basic_widgets.dart';
import 'package:hue_helper/palette_type.dart';

import 'finished_palette.dart';
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

  @override
  Widget build(BuildContext context) {

    HSLColor mainPaletteColor = HSLColor.fromColor(widget.adjustedColor);

    //create a palette with the amount of colors given
    palette = List.filled(_paletteSize, mainPaletteColor);

    //generate a palette
    palette = calculateOtherColors(PaletteTypeState.type, palette, _paletteSize, _hueVarianceValue, _saturationVarianceValue, _luminanceVarianceValue);

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
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 5.0,
                                    ),
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