import 'package:flutter/material.dart';

class ColorInfo
{
  Color color;
  String name;

  ColorInfo(this.color, this.name);
}

class ColorChoice extends StatelessWidget {
  ColorChoice({Key? key}) : super(key: key);

  final List<ColorInfo> colorList = [];

  @override
  Widget build(BuildContext context) {

    colorList.add(ColorInfo(Color(0xFFFF0000), 'red'));
    colorList.add(ColorInfo(Color(0xFFFF5100), 'orange'));
    colorList.add(ColorInfo(Color(0xFFFFB600), 'yellow'));
    colorList.add(ColorInfo(Color(0xFFC8FF00), 'lime'));
    colorList.add(ColorInfo(Color(0xFF5CFF00), 'green'));
    colorList.add(ColorInfo(Color(0xFF00D9FF), 'teal'));
    colorList.add(ColorInfo(Color(0xFF0038FF), 'blue'));
    colorList.add(ColorInfo(Color(0xFFA600FF), 'purple'));

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
                                      })),
                            ),
                        ],
                      ),
                    )),
              ],
            )));
  }
}
