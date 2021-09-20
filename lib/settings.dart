import 'package:flutter/material.dart';

import 'main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                        'settings',
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
                                      builder: (context) => MyApp()),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )));
  }
}
