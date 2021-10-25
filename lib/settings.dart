import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hue_helper/basic_widgets.dart';
import 'main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  int currentIndex = 0;
  Color selectedColor = Colors.black; //a default value that will never be shown

  void changePrimaryColor(Color color){
    setState(() {
      ThemeColors.primaryColor = color;
    });
  }

  void changeSecondaryColor(Color color){
    setState(() {
      ThemeColors.secondaryColor = color;
    });
  }

  void changeTertiaryColor(Color color){
    setState(() {
      ThemeColors.tertiaryColor = color;
    });
  }

  void changeFourthColor(Color color){
    setState(() {
      ThemeColors.fourthColor = color;
    });
  }

  void changeBackgroundColor(Color color){
    setState(() {
      ThemeColors.backgroundColor = color;
    });
  }

  void selectColor(int index){
    switch(index)
    {
      case 0: selectedColor = ThemeColors.primaryColor; return;
      case 1: selectedColor = ThemeColors.secondaryColor; return;
      case 2: selectedColor = ThemeColors.tertiaryColor; return;
      case 3: selectedColor = ThemeColors.fourthColor; return;
      case 4: selectedColor = ThemeColors.backgroundColor; return;
    }
  }

  Function(Color) determineFunction(int index)
  {
    switch(index)
    {
      case 0: return changePrimaryColor;
      case 1: return changeSecondaryColor;
      case 2: return changeTertiaryColor;
      case 3: return changeFourthColor;
      case 4: return changeBackgroundColor;
    }
    return changeSecondaryColor;
  }

  Widget createColorPicker(String title, Function(Color) change)
  {
    return ColorPicker(
      pickerColor: selectedColor,
      onColorChanged: change,
      showLabel: true,
      enableAlpha: false,
      portraitOnly: true,
      displayThumbColor: true,
      pickerAreaHeightPercent: 0.8,
    );
  }

  Widget createColorButton(Color associatedColor, String title, int associatedIndex)
  {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: associatedColor,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40),
        ),),
      child: Text(title),
      onPressed: (){
        setState(() {
          print("changed index to " + associatedIndex.toString());

          currentIndex = associatedIndex;
          selectColor(associatedIndex);

          print(selectedColor);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [
                createTopText("settings"),
                Expanded(
                    flex: 80,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            createColorButton(ThemeColors.primaryColor, '1', 0),
                            createColorButton(ThemeColors.secondaryColor, '2', 1),
                            createColorButton(ThemeColors.tertiaryColor, '3', 2),
                            createColorButton(ThemeColors.fourthColor, '4', 3),
                            createColorButton(ThemeColors.backgroundColor, '5', 4),
                          ],),
                        createColorPicker('?', determineFunction(currentIndex))
                      ],
                    )
                ),
                createBottomRow(Icons.settings, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title: '')),
                  );
                }),
              ],
            )));
  }
}
