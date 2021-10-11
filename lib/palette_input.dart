import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PaletteInput extends StatefulWidget {
  const PaletteInput({Key? key}) : super(key: key);

  @override
  _PaletteInputState createState() => _PaletteInputState();
}

class _PaletteInputState extends State<PaletteInput> {

  Color pickerColor = Colors.blue;
  int currentIndex = 0;

  int _paletteSize = 4;
  List<Color> palette = List.generate(6, (index) => Colors.black87);

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

    print("Palette length is " + palette.length.toString());
    print("Palette size is " + _paletteSize.toString());
    print("Current index is " + currentIndex.toString());
    //palette = List.filled(_paletteSize, Colors.black87);

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
                            color: palette[i],
                            margin: EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                child: Text("hi!"),
                                onPressed: (){
                                  selectColor(i);
                                  print("changed index to " + i.toString());
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
                            onPressed: () {},
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
