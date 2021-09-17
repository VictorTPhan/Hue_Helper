import 'package:flutter/material.dart';
import 'package:hue_helper/main.dart';

class FinishedPalette extends StatelessWidget {
  const FinishedPalette({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        'voila!',
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
                      margin: EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(8.0),
                                color: Color(0xFFFF0000)),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(8.0),
                                color: Color(0xFFFF6F00)),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(8.0),
                                color: Color(0xFFFFDD00)),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(8.0),
                                color: Color(0xFFB3FF00)),
                          ),
                        ],
                      ),
                    )
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      MyHomePage(title: 'Flutter Demo Home Page'))
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
