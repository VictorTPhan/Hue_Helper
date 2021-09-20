import 'package:flutter/material.dart';
import 'package:hue_helper/color_adjustment.dart';
import 'color_data.dart';

class ColorInfo extends StatelessWidget {

  const ColorInfo({Key? key, required this.colorData}) : super(key: key);

  final ColorData colorData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      color: colorData.color,
                      alignment: Alignment.center,
                      child: Text(
                        colorData.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 80,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                colorData.name[0].toUpperCase() + colorData.name.substring(1,colorData.name.length) + ' is a ' + typeText + ' color. ' + colorData.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                              fontSize: 25,
                              )
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: colorData.color,
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                colorData.name + ' is commonly associated with:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: colorData.colorDescriptors.length,
                                itemBuilder: (context, index)
                                {
                                  return ListTile(
                                    title: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text("• " + colorData.colorDescriptors[index],
                                          style: TextStyle(
                                            fontSize: 20,
                                          )
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    )),
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
                              backgroundColor: colorData.color,
                              shape: CircleBorder(),
                            ),
                            child: Icon(Icons.arrow_forward, color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ColorAdjustment(givenColor: colorData)),
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

  String get typeText {
    switch (colorData.type){
      case colorType.primary:
        return 'primary';
      case colorType.secondary:
        return 'secondary';
      case colorType.tertiary:
        return 'tertiary';
      default:
        return 'UNKNOWN';
    }
  }
}
