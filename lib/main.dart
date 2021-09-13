import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: [
          Expanded(
            flex: 40,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Image(
                image: NetworkImage('https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fimg1.wikia.nocookie.net%2F__cb20140805211145%2Fbionicle%2Fimages%2Ff%2Ff6%2FTahu_keyv.jpg&f=1&nofb=1'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 50,
            child: Container(
              width: 300,
              margin: EdgeInsets.only(bottom: 20),
              color: Colors.grey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width:double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text("i need a palette"),
                      onPressed: () {
                        print("pressed");
                      },
                    ),
                  ),
                  SizedBox(
                    width:double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text("i have a palette"),
                      onPressed: () {
                        print("pressed");
                      },
                    ),
                  ),
                  SizedBox(
                    width:double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text("any palette, please"),
                      onPressed: () {
                        print("pressed");
                      },
                    ),
                  ),
                  SizedBox(
                    width:double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text("my palettes"),
                      onPressed: () {
                        print("pressed");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      onPressed: ()
                      {

                      },
                      icon: const Icon(Icons.settings)
                  )
                ]
            )
          )
        ],
      ),
    );
  }
}
