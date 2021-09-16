import 'package:flutter/material.dart';
import 'package:hue_helper/palette_type.dart';

class MonochromeInfo extends StatefulWidget {
  const MonochromeInfo({Key? key}) : super(key: key);

  @override
  _MonochromeInfoState createState() => _MonochromeInfoState();
}

class _MonochromeInfoState extends State<MonochromeInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [
                Expanded(
                    flex: 10,
                    child: Container(
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        'monochromatic',
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
                          Expanded(child: Image(image: NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcloud.netlifyusercontent.com%2Fassets%2F344dbf88-fdf9-42bb-adb4-46f01eedd629%2Fdf9b5610-8d06-4823-a37f-adedf8218538%2F1-large-opt.png&f=1&nofb=1'))),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('All colors within a monochromatic color scheme are variations of the same color, with different tints and shades. The main color can be any color of hue, saturation, or value. All colors in a this scheme are guaranteed to be harmonious.',
                            style: TextStyle(
                                  fontSize: 18,
                            )
                            ),
                          ))
                        ],),
                    ),
                      Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Monochromatic palettes can be described as:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text("• soothing",
                          style: TextStyle(
                          fontSize: 20,
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text("• calming",
                            style: TextStyle(
                              fontSize: 20,
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text("• consistent",
                            style: TextStyle(
                              fontSize: 20,
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text("• simple, but effective",
                            style: TextStyle(
                              fontSize: 20,
                            )
                        ),
                      ),
                  ],)
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PaletteType())
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PaletteType())
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
