import 'package:flutter/material.dart';
import 'package:hue_helper/basic_widgets.dart';
import 'package:hue_helper/main.dart';

class FinishedPalette extends StatefulWidget {
  const FinishedPalette({Key? key, required this.finalPalette}) : super(key: key);

  final List<HSLColor> finalPalette;

  @override
  _FinishedPaletteState createState() => _FinishedPaletteState();
}

class _FinishedPaletteState extends State<FinishedPalette> {

  bool hexCodeOn = false;

  void toggleHexCode()
  {
    if (hexCodeOn) {hexCodeOn = false; return;}
    else {hexCodeOn = true; return;}
  }

  String getHexCode(HSLColor c)
  {
    return "#" + c.toColor().value.toRadixString(16);
  }
  
  Widget getHexBox(HSLColor c)
  {
    if (!hexCodeOn) return Text("");
    return Text('   ' + getHexCode(c) + '   ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.white,
          backgroundColor: Color(0x800F0436),
        )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                createTopText("here it is!"),
                Expanded(
                    flex: 80,
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i in widget.finalPalette)
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: i.toColor(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                margin: EdgeInsets.all(15),
                                child: getHexBox(i),
                      ),
                    ),
                ],
              ),
                    )
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size.fromHeight(100),
                              backgroundColor: ThemeColors.fourthColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(Icons.palette, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                toggleHexCode();
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size.fromHeight(100),
                              backgroundColor: ThemeColors.fourthColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
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
