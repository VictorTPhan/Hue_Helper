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
                      color: Theme.of(context).primaryColor,
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
                              decoration: BoxDecoration(
                                  color: Color(0xFFFF0000),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              margin: EdgeInsets.all(15),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFA200),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              margin: EdgeInsets.all(15),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF00FF66),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              margin: EdgeInsets.all(15),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF0066FF),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              margin: EdgeInsets.all(15),
                            ),
                          ),
                        ],
                      ),
                    )
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
                                    builder: (context) => MyApp()),
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
