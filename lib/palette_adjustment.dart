import 'package:flutter/material.dart';

import 'finished_palette.dart';

class PaletteAdjustment extends StatefulWidget {
  const PaletteAdjustment({Key? key}) : super(key: key);

  @override
  _PaletteAdjustmentState createState() => _PaletteAdjustmentState();
}

class _PaletteAdjustmentState extends State<PaletteAdjustment> {

  double _hueVarianceValue = 0;
  double _saturationVarianceValue = 0;
  double _luminanceVarianceValue = 0;
  int _paletteSize = 4;

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
                        'lets finalize the palette',
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
                              Text('Hue',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how much should the other colors differ in hue?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
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
                              Text('Saturation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how intense should the other hues be?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
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
                              Text('Luminance',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),
                              Text('how bright should the other colors be?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                    value: _luminanceVarianceValue,
                                    min: 0,
                                    max: 100,
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
                  child: Row(
                    children: [
                      for (int i = 0; i<_paletteSize; i++)
                        Expanded(
                          child: Container(

                          ),
                        )
                    ],
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FinishedPalette())
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