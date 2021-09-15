import 'package:flutter/material.dart';

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
                        onPressed: () {},
                        child: Text('monocolor',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('analogous')),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('complementary')),
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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                )
              ],
            ),
          ),
        )
      ],
    )));
  }
}
