import 'package:flutter/material.dart';

//these will be change-able in the settings menu
class ThemeColors {
    static const primaryColor = Color(0xFF005CE7);
    static const secondaryColor = Color(0xFF1A75FF);
    static const tertiaryColor = Color(0xFF3D8BFF);
    static const fourthColor = Color(0xFF61A0FF);
    static const backgroundColor = Color(0xFFD1E3FF); //should be very light
}

Widget createTopText(String topText)
{
    return Expanded(
        flex: 10,
        child: Container(
            color: ThemeColors.primaryColor,
            alignment: Alignment.center,
            child: Text(
                topText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                ),
            ),
        )
    );
}

//nextScreen is what would typically go in onPressed
Widget createBottomRow(IconData iconLabel, Function nextScreen)
{
    return Expanded(
      flex: 10,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              child: TextButton(
                style: TextButton.styleFrom( //there is no text, but we can add an icon instead
                  fixedSize: Size.fromHeight(100),
                  backgroundColor: ThemeColors.fourthColor,
                  shape: CircleBorder(),
                ),
                child: Icon(iconLabel, color: Colors.black),
                onPressed: () {
                  nextScreen();
                },
              ),
            )
          ],
        ),
      ),
    );
}

Widget createSlider(double adjustableVariable, String title, String description, double min, double max, Function onSliderChanged(double value))
{
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ThemeColors.fourthColor,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Text('   '+title+'   ', //add some space in the title
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              )),
        ),
        Text(description,
            style: TextStyle(
              color: ThemeColors.primaryColor,
              fontSize: 20,
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slider(
              activeColor: ThemeColors.secondaryColor,
              inactiveColor: ThemeColors.fourthColor,
              value: adjustableVariable,
              min: min,
              max: max,
              label: adjustableVariable.round().toString(),
              onChanged: (double value) { onSliderChanged(value); }
          ),
        )
      ],
    ),
  );
}