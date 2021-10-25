import 'package:flutter/material.dart';
import 'package:hue_helper/color_choice.dart';
import 'package:hue_helper/main.dart';

import 'basic_widgets.dart';

class PaletteInfo extends StatelessWidget {
  const PaletteInfo({Key? key,
    required this.paletteType,
    required this.paletteDescription,
    required this.paletteImage,
    required this.paletteDescriptors}) : super(key: key);

  final String paletteType;
  final String paletteDescription;
  final Image paletteImage;
  final List<String> paletteDescriptors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [
                createTopText(paletteType),
                Expanded(
                    flex: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: paletteImage),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(paletteDescription,
                                    style: TextStyle(
                                      fontSize: 18,
                                    )
                                ),
                              ))
                            ],),
                        ),
                        Container(
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeColors.tertiaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(50))),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(paletteType + " palettes can be described as:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                )),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: paletteDescriptors.length,
                              itemBuilder: (context, index)
                              {
                                 return ListTile(
                                   title: Container(
                                     margin: EdgeInsets.all(10),
                                     child: Text("• " + paletteDescriptors[index],
                                         style: TextStyle(
                                           fontSize: 20,
                                         )
                                     ),
                                   ),
                                 );
                              }
                          ),
                        ),
                      ],)
                ),
                createBottomRow(Icons.arrow_forward, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ColorChoice()),
                  );
                }),
              ],
            )));
  }
}
