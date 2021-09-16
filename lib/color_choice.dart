import 'package:flutter/material.dart';
import 'package:hue_helper/color_info.dart';
import 'color_data.dart';

class ColorChoice extends StatelessWidget {
  ColorChoice({Key? key}) : super(key: key);

  final List<ColorData> colorList = [];

  @override
  Widget build(BuildContext context) {

    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
        colorType.primary,
        'this is a special color. not really but i had you tricked for a good second or two',
        ['passion','anger','boldness']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));
    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
            colorType.primary,
            '',
            ['lorem ipsum','lorem ipsum','lorem ipsum']));

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
                        'choose a main color',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 90,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for(var i in colorList)
                            Expanded(
                              child: Container(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: i.color,
                                    ),
                                      child: Text(
                                        i.name,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ColorInfo(colorData: i)),
                                      );
                                    }
                                  )),
                            ),
                        ],
                      ),
                    )),
              ],
            )));
  }
}
