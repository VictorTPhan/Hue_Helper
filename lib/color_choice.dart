import 'package:flutter/material.dart';
import 'package:hue_helper/color_info.dart';
import 'color_data.dart';
import 'main.dart';

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
        ['passion','anger','fire', 'courageousness'],
        337, 14));
    colorList.add(
        ColorData(Color(0xFFFF7700),
            'orange',
            colorType.secondary,
            'Orange is one of the boldest warm colors, and is often used in advertising and public safety equipment; for example, traffic cones, safety vests, and hard hats.',
            ['boldness','drawing attention','energy'],
        15, 41));
    colorList.add(
        ColorData(Color(0xFFFFE900),
            'yellow',
            colorType.primary,
            'Yellow is one of the brightest of the warm colors. Much like orange, it is often used in both advertising and public safety signs. Red and yellow are very common color combinations for advertisements, and yellow is the go-to color for most road signs.',
            ['brightness', 'happiness', 'vibrancy', 'youth'],
        42, 71));
    colorList.add(
        ColorData(Color(0xFF90FF00),
            'lime',
            colorType.primary,
            'Alongside normal green, lime is the de-facto color for nature. In many respects its associations are similar to that of yellow.',
            ['nature', 'harmony', 'wealth', 'restlessness'],
        72, 99));
    colorList.add(
        ColorData(Color(0xFF21FF00),
            'green',
            colorType.primary,
            'Green is the most common color used in relation to nature. Throughout many years of evolution, humans have best learned to differentiate hues of green.',
            ['nature', 'tranquility', 'environmental awareness', 'good health'],
        100, 151));
    colorList.add(
        ColorData(Color(0xFF00F6FF),
            'cyan',
            colorType.primary,
            'Cyan is one of the most commonly used colors for apps and branding. Check the apps on your phone. How many apps implement cyan or a variant of cyan in some fashion?',
            ['focus', 'concentration', 'calming', 'analytics'],
        152, 207));
    colorList.add(
        ColorData(Color(0xFF0000FF),
            'blue',
            colorType.primary,
            'Blue is a color with some of the most varied associations. It is also one of the most commonly selected colors. Blue is one the coldest colors.',
            ['sadness', 'coldness', 'serenity', 'the ocean', 'productivity'],
        208, 257));
    colorList.add(
        ColorData(Color(0xFFA100FF),
            'purple',
            colorType.primary,
            'Historically a rare color due to difficulties in procuring purple dyes, purple has long been used only by kings and queens as part of their royal fashion.',
            ['wealth', 'royalty', 'mystery'],
        258, 292));
    colorList.add(
        ColorData(Color(0xFFFF01B1),
            'magenta',
            colorType.primary,
            'Historically a rare color due to difficulties in procuring purple dyes, purple has long been used only by kings and queens as part of their royal fashion.',
            ['wealth', 'royalty', 'mystery'],
            293, 336));

    return Scaffold(
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      color: ThemeColors.primaryColor,
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
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for(var i in colorList)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: i.color,
                                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
                                        ),),
                                        child: Text(
                                          i.name,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black87,
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
                            ),
                        ],
                      ),
                    )),
              ],
            )));
  }
}
