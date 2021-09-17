import 'package:flutter/material.dart';
import 'package:hue_helper/color_info.dart';
import 'color_data.dart';

class ColorChoice extends StatelessWidget {
  ColorChoice({Key? key}) : super(key: key);

  final List<ColorData> colorList = [];

  @override
  Widget build(BuildContext context) {

    //all information about colors taken from verywellmind.com

    colorList.add(
        ColorData(Color(0xFFFF0000),
            'red',
        colorType.primary,
        'Red has had a long symbolic history throughout nearly all cultures, and is the most common color used in palettes.',
        ['passion','anger','fire', 'courageousness']));
    colorList.add(
        ColorData(Color(0xFFFF6F00),
            'orange',
            colorType.secondary,
            'Orange is one of the boldest warm colors, and is often used in advertising and public safety equipment; for example, traffic cones, safety vests, and hard hats.',
            ['boldness','drawing attention','energy']));
    colorList.add(
        ColorData(Color(0xFFFFDD00),
            'yellow',
            colorType.primary,
            'Yellow is one of the brightest of the warm colors. Much like orange, it is often used in both advertising and public safety signs. Red and yellow are very common color combinations for advertisements, and yellow is the go-to color for most road signs.',
            ['brightness', 'happiness', 'vibrancy', 'youth']));
    colorList.add(
        ColorData(Color(0xFFB3FF00),
            'lime',
            colorType.primary,
            'Alongside normal green, lime is the de-facto color for nature. In many respects its associations are similar to that of yellow.',
            ['nature', 'harmony', 'wealth', 'restlessness']));
    colorList.add(
        ColorData(Color(0xFF08FF00),
            'green',
            colorType.primary,
            'Green is the most common color used in relation to nature. Throughout many years of evolution, humans have best learned to differentiate hues of green.',
            ['nature', 'tranquility', 'environmental awareness', 'good health']));
    colorList.add(
        ColorData(Color(0xFF00CCFF),
            'cyan',
            colorType.primary,
            'Cyan is one of the most commonly used colors for apps and branding. Check the apps on your phone. How many apps implement cyan or a variant of cyan in some fashion?',
            ['focus', 'concentration', 'calming', 'analytics']));
    colorList.add(
        ColorData(Color(0xFF0040FF),
            'blue',
            colorType.primary,
            'Blue is a color with some of the most varied associations. It is also one of the most commonly selected colors. Blue is one the coldest colors.',
            ['sadness', 'coldness', 'serenity', 'the ocean', 'productivity']));
    colorList.add(
        ColorData(Color(0xFFA600FF),
            'purple',
            colorType.primary,
            'Historically a rare color due to difficulties in procuring purple dyes, purple has long been used only by kings and queens as part of their royal fashion.',
            ['wealth', 'royalty', 'mystery']));

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
