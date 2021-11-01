import 'package:flutter/material.dart';
import 'package:hue_helper/color_info.dart';
import 'basic_widgets.dart';
import 'color_data.dart';
import 'main.dart';

class ColorChoice extends StatelessWidget {
  ColorChoice({Key? key}) : super(key: key);

  final List<ColorData> colorList = [];

  @override
  Widget build(BuildContext context) {

    colorList.add(
        ColorData(Color(0xFFFF0E0E),
            'red',
        colorType.primary,
        'Red has had a long symbolic history throughout nearly all cultures, as a representation of boldness and fiery resolve, and is the most common color used in palettes.',
        ['passion','anger','fire', 'courageousness'],
        337, 14));
    colorList.add(
        ColorData(Color(0xFFFF7900),
            'orange',
            colorType.secondary,
            "Orange contains many of the qualities of its neighbors, but it is unique in its boldness. It's why orange is commonly seen in safety equipment or cautionary signs.",
            ['boldness','attentiveness','energy', 'earthiness (when darkened)', 'autumn'],
        15, 41));
    colorList.add(
        ColorData(Color(0xFFFFD900),
            'yellow',
            colorType.primary,
            'Yellow is one of the lightest of hues. It is commonly used in conjunction with red in advertisements (think fast-food), and also in many road-signs.',
            ['brightness', 'happiness', 'vibrancy', 'youth', 'creativity'],
        42, 71));
    colorList.add(
        ColorData(Color(0xFF90FF00),
            'lime',
            colorType.tertiary,
            'Alongside normal green, lime is the de-facto color for nature. In many respects its associations are similar to that of yellow.',
            ['nature', 'harmony', 'wealth', 'restlessness'],
        72, 99));
    colorList.add(
        ColorData(Color(0xFF21FF00),
            'green',
            colorType.secondary,
            'Green is the most common color used in relation to nature (for obvious reasons). Such is why there are more perceived shades of green than other colors.',
            ['nature', 'success', 'tranquility', 'envy', 'good health'],
        100, 151));
    colorList.add(
        ColorData(Color(0xFF00F6FF),
            'cyan',
            colorType.secondary,
            'Cyan is one of the most commonly used colors for apps and branding. Check the apps on your phone. How many apps implement cyan or a variant of cyan in some fashion?',
            ['focus', 'concentration', 'calming', 'analytics'],
        152, 207));
    colorList.add(
        ColorData(Color(0xFF3553E8),
            'blue',
            colorType.primary,
            "Next to green, blue is perhaps one of the most common colors, representing generally anything related to water. Blue is considered the coldest color in the spectrum.",
            ['sadness', 'coldness', 'calmness', 'water (ocean or ice)', 'productivity'],
        208, 257));
    colorList.add(
        ColorData(Color(0xFFA100FF),
            'purple',
            colorType.secondary,
            'Historically a rare color due to difficulties in procuring purple dyes, purple has long been used only by kings and queens as part of their royal fashion. Everything associated with royality similarly applies to purple.',
            ['wealth', 'royalty', 'mystery', 'deviance', 'corruption', 'poison'],
        258, 292));
    colorList.add(
        ColorData(Color(0xFFFF01B1),
            'magenta',
            colorType.tertiary,
            'Magenta is a semi-common color in nature, typically found in plants. When toned down, it is a very relaxing color. On the same token, when highly saturated, magenta can be both striking and extremely bold.',
            ['energy', 'prettiness', 'youth', 'obnoxiousness'],
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0x800F0436),
                                              borderRadius: BorderRadius.all(Radius.circular(30))),
                                          child: Text('   ' + i.name + '   ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              )),
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
