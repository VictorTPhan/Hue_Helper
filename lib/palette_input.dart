import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hue_helper/basic_widgets.dart';
import 'package:hue_helper/palette_analysis.dart';

import 'main.dart';

class PaletteInput extends StatefulWidget {
  const PaletteInput({Key? key}) : super(key: key);

  @override
  _PaletteInputState createState() => _PaletteInputState();
}

class _PaletteInputState extends State<PaletteInput> {

  Color pickerColor = Colors.blue;
  int currentIndex = 0;

  int _paletteSize = 4;
  List<Color> palette = List.generate(6, (index) => ThemeColors.primaryColor);

  void selectColor(int index){
    currentIndex = index;
  }

  void changeSelectedColor(Color color) {
    pickerColor = color;
  }

  void changeColor(Color color){
    setState(() {
      pickerColor = color;
      palette[currentIndex] = color;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Column(
              children: [
                createTopText("input your palette"),
                //the slider
                Expanded(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Column(
                            children: [
                              Text('Palette Size',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how many colors do you have?',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    value: _paletteSize.toDouble(),
                                    min: 2,
                                    max: 6,
                                    divisions: 4,
                                    label: _paletteSize.toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _paletteSize = value.toInt();
                                        print(_paletteSize);
                                      });
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                      ],)
                ),
                //the palette icons
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      for (int i = 0; i<_paletteSize; i++)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: palette[i],
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(40),
                                    side: BorderSide(color: Colors.black, width: 5.0),
                                  ),),
                                child: Container(),
                                onPressed: (){
                                  setState(() {
                                    selectColor(i);
                                    print("changed index to " + i.toString());
                                  });
                                },
                              ),
                          ),
                        )
                    ],
                  ),
                ),
                //the color picker
                Expanded(
                  flex: 45,
                  child: ColorPicker(
                    pickerColor: palette[currentIndex],
                    onColorChanged: changeColor,
                    showLabel: true,
                    enableAlpha: false,
                    portraitOnly: true,
                    displayThumbColor: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                createBottomRow(Icons.settings, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaletteAnalysis(palette: palette, paletteSize: _paletteSize,)),
                  );
                }),
              ],
            )));
  }
}
