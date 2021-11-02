import 'package:flutter/material.dart';
import 'package:hue_helper/palette_type.dart';

//these will be change-able in the settings menu
class ThemeColors {
    static Color primaryColor = Color(0xFF005CE7);
    static Color secondaryColor = Color(0xFF1A75FF);
    static Color tertiaryColor = Color(0xFF3D8BFF);
    static Color fourthColor = Color(0xFF61A0FF);
    static Color backgroundColor = Color(0xFFD1E3FF); //should be very light
}

//creates a top bar for screens, with a default color.
//String topText - what should the top bar say?
Widget createTopText(String topText)
{
    return createTopTextWithColor(topText, ThemeColors.primaryColor);
}

//creates a top bar for screens.
//String topText - what should the top bar say?
//Color topColor - what color should the top bar be?
Widget createTopTextWithColor(String topText, Color topColor)
{
  return Expanded(
      flex: 10,
      child: Container(
        color: topColor,
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

//Creates a bottom row which houses a navigation button.
//IconData iconLabel - what should the navigation button look like?
//Function nextScreen - what would typically go in onPressed
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

//creates a slider with a preset size and look.
//double adjustableVariable - what do you want to adjust?
//String title - what does this slider represent?
//String description - enter any additional information the user should know.
//double min, max - what are the bounds of your slider (max > min)
//Function onSliderChanged(double value) - what should happen when the slider is adjusted?
Widget createSlider(double adjustableVariable, String title, String description, double min, double max, Function onSliderChanged(double value))
{
  if (adjustableVariable > max) adjustableVariable = max;
  if (adjustableVariable < min) adjustableVariable = min;

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

//depending on the palette organization, this will assign them differently
//assume palette[0] = adjustedColor
//creates a palette given a starting color and variance information.
//PaletteOrganizationt type - what palette are you going for?
//List<HSLColor> palette - the palette you will assign colors to.
//int _paletteSize - how big the palette is
//double _hueVarianceValue - how much do you want the hues to shift?
//double _saturationVarianceValue - how much contrast do you want in saturation?
//double _luminanceVarianceValue - how much contrast do you want in values?
List<HSLColor> calculateOtherColors(PaletteOrganization type, List<HSLColor> palette, int _paletteSize, double _hueVarianceValue, double _saturationVarianceValue, double _luminanceVarianceValue)
{
  //correct any colors that are too high (if for whatever reason they are)
  if (_hueVarianceValue > 360) _hueVarianceValue-=360;
  if (_saturationVarianceValue > 1) _saturationVarianceValue-=1;
  if (_luminanceVarianceValue > 1) _luminanceVarianceValue-=1;

  HSLColor referenceColor = palette[0];
  double hueVariance = _hueVarianceValue/_paletteSize;
  double saturationVariance = _saturationVarianceValue/_paletteSize;

  int halfWay = (_paletteSize/2).round();

  switch(type)
  {
    case PaletteOrganization.monochromatic:

    //at luminanceVariance = 0, the colors should all be the base color
    //at luminanceVariance = 1, the colors should range from pitch black to pure white

      double negLumRange = referenceColor.lightness * (_luminanceVarianceValue/1.0);
      for (int i = 1; i <= halfWay; i++)
      {
        palette[i-1] = referenceColor.withLightness(referenceColor.lightness - negLumRange * ((halfWay-i+1)/halfWay));
      }

      double posLumRange = (1-referenceColor.lightness) * (_luminanceVarianceValue/1.0);
      for (int i = halfWay+2; i <= _paletteSize; i++)
      {
        palette[i-1] = referenceColor.withLightness(referenceColor.lightness + posLumRange *(i/_paletteSize));
      }

      //subtly change hue and saturation
      for (int i = 0; i<_paletteSize; i++) {
        double hueDelta = referenceColor.hue + hueVariance * i;
        if (hueDelta < 0) hueDelta+=360;
        if (hueDelta > 360) hueDelta-=360;
        palette[i] = palette[i].withHue(hueDelta);

        palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVariance * i).clamp(0, 1));
      }

      return palette;
    case PaletteOrganization.analogous:

      double posLumRange = (1-referenceColor.lightness) * (_luminanceVarianceValue/1.0);

      for (int i = 0; i<_paletteSize; i++)
      {
        //change luminance
        palette[i] = referenceColor.withLightness(referenceColor.lightness + posLumRange * (i/_paletteSize));

        //change saturation
        palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVariance * i).clamp(0, 1));

        //change hues
        double hueDelta = referenceColor.hue + hueVariance * i;
        if (hueDelta < 0) hueDelta+=360;
        if (hueDelta > 360) hueDelta-=360;
        palette[i] = palette[i].withHue(hueDelta);
      }
      return palette;
    case PaletteOrganization.complementary:
      double saturationVarianceComplementary = _saturationVarianceValue/2;
      double oppositeHue = (180-referenceColor.hue).abs();
      double posLumRange = (1-referenceColor.lightness) * (_luminanceVarianceValue/1.0);

      for (int i = 0; i< halfWay; i++)
      {
        //change lightness
        palette[i] = referenceColor.withLightness(referenceColor.lightness + posLumRange * ((i+1)/halfWay));

        //change hues
        double hueDelta = referenceColor.hue + hueVariance * i;
        if (hueDelta < 0) hueDelta+=360;
        if (hueDelta > 360) hueDelta-=360;
        palette[i] = palette[i].withHue(hueDelta);

        //change saturation
        palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVarianceComplementary * i).clamp(0, 1));
      }

      for (int i = halfWay; i< _paletteSize; i++)
      {
        //change lightness
        palette[i] = referenceColor.withLightness((referenceColor.lightness + posLumRange * (i-2)/(_paletteSize-halfWay)).clamp(0, 1));

        //change hues
        double hueDelta = (oppositeHue - hueVariance * (i-halfWay));
        if (hueDelta < 0) hueDelta+=360;
        if (hueDelta > 360) hueDelta-=360;
        palette[i] = palette[i].withHue(hueDelta);

        //change saturation
        palette[i] = palette[i].withSaturation((referenceColor.saturation + saturationVarianceComplementary).clamp(0, 1));
      }
      return palette;
  }
}