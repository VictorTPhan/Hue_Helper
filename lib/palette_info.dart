import 'package:flutter/material.dart';
import 'package:hue_helper/color_choice.dart';

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
                Expanded(
                    flex: 10,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                      child: Text(
                        paletteType,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
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
                          color: Colors.blue,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Theme.of(context).primaryColor,
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
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ColorChoice()),
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
