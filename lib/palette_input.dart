import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
                Expanded(
                    flex: 10,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                      child: Text(
                        'input your palette here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 20,
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
                              Text('how many colors do you want?',
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
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      for (int i = 0; i<_paletteSize; i++)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: palette[i],
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                                  ),),
                                child: Text("hi!"),
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
                Expanded(
                  flex: 50,
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
                                  //TODO: Create a settings screen
                                    builder: (context) => PaletteAnalysis(palette: palette.sublist(0, _paletteSize))),
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
