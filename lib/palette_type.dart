import 'package:flutter/material.dart';
import 'package:hue_helper/main.dart';
import 'package:hue_helper/palette_info.dart';

class PaletteType extends StatefulWidget {
  const PaletteType({Key? key}) : super(key: key);

  @override
  _PaletteTypeState createState() => _PaletteTypeState();
}

class _PaletteTypeState extends State<PaletteType> {
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
                'choose a palette type',
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
            margin: EdgeInsets.only(left: 50, right: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  PaletteInfo(paletteType: 'monochromatic',
                                      paletteDescription: 'All colors within a monochromatic color scheme are variations of the same color, with different tints and shades. The main color can be any color of hue, saturation, or value. All colors in a this scheme are guaranteed to be harmonious.',
                                      paletteImage: Image(image: NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcloud.netlifyusercontent.com%2Fassets%2F344dbf88-fdf9-42bb-adb4-46f01eedd629%2Fdf9b5610-8d06-4823-a37f-adedf8218538%2F1-large-opt.png&f=1&nofb=1')),
                                      paletteDescriptors: ['soothing','calming','consistent','simple, but effective']))
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('monochromatic',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                )
                            ),
                          ),
                          Text('a main color with brightness variations'),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(children: [
                              Icon(Icons.circle, size: 75, color: Color(0xFF380802),),
                              Icon(Icons.circle, size: 75, color: Color(0xFF911507),),
                              Icon(Icons.circle, size: 75, color: Color(0xFFFF240C),),
                              Icon(Icons.circle, size: 75, color: Color(0xFFFFA096),),
                            ]),
                          )
                        ])
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  PaletteInfo(paletteType: 'analogous',
                                      paletteDescription: 'All colors within an analogous color scheme are variations of the same color, with hues shifted to ones adjacent to the main color hue on a color wheel. The main color can be of any hue, saturation, or value.',
                                      paletteImage: Image(image: NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcloud.netlifyusercontent.com%2Fassets%2F344dbf88-fdf9-42bb-adb4-46f01eedd629%2Fdf9b5610-8d06-4823-a37f-adedf8218538%2F1-large-opt.png&f=1&nofb=1')),
                                      paletteDescriptors: ['interconnected', 'cohesive', 'easy on the eyes', 'dynamic']))
                          );
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('analogous',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    )
                                ),
                              ),
                              Text('a main color with hue offshoots'),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(children: [
                                  Icon(Icons.circle, size: 75, color: Color(0xFFFF0094),),
                                  Icon(Icons.circle, size: 75, color: Color(0xFFFF240C),),
                                  Icon(Icons.circle, size: 75, color: Color(0xFFFF3B00),),
                                  Icon(Icons.circle, size: 75, color: Color(0xFFFF8C00),),
                                ]),
                              )
                            ])
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                              PaletteInfo(paletteType: 'complementary',
                                  paletteDescription: 'There are two main colors in a complementary scheme: a main color, and its opposite on the color wheel. All colors are variations of these two colors in hue, saturation, or value. The main colors can be of any hue, saturation, or value.',
                                  paletteImage: Image(image: NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcloud.netlifyusercontent.com%2Fassets%2F344dbf88-fdf9-42bb-adb4-46f01eedd629%2Fdf9b5610-8d06-4823-a37f-adedf8218538%2F1-large-opt.png&f=1&nofb=1')),
                                  paletteDescriptors: ['bold', 'striking', 'loud', 'energetic']))
                          );
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('complementary',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    )
                                ),
                              ),
                              Text('two opposing colors, with some variation'),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(children: [
                                  Icon(Icons.circle, size: 75, color: Color(0xFFFF240C),),
                                  Icon(Icons.circle, size: 75, color: Color(0xFFFF002E),),
                                  Icon(Icons.circle, size: 75, color: Color(0xFF00FFA5),),
                                  Icon(Icons.circle, size: 75, color: Color(0xFF00FF72),),
                                ]),
                              )
                            ])
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                          MaterialPageRoute(builder: (context) => MyApp())
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
