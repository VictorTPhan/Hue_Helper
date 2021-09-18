import 'package:flutter/material.dart';

enum colorType {primary, secondary, tertiary}

class ColorData
{
  Color color;
  String name;
  colorType type;
  String description;
  List<String> colorDescriptors;
  int lowLimit;
  int highLimit;

  ColorData(
      this.color,
      this.name,
      this.type,
      this.description,
      this.colorDescriptors,
      this.lowLimit,
      this.highLimit,
      );
}