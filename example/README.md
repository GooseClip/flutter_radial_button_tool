# flutter_radial_button_tool

An example application of the flutter_radial_botton_tool package

## Getting start

`flutter pub add flutter_radial_tool_button`

## Features

Dynamic radial button tool for flutter

<img src="https://github.com/gooseclip/flutter_radial_button_tool/raw/main/demo.gif">

## Usage

```dart
import 'package:flutter_radial_button_tool/flutter_radial_button_tool.dart';
import 'package:example/radial_icon_button.dart';

List<Color> backgroundColors = [
const Color(0xFF5CED81), // 1
const Color(0xFF62D5E4), // 2
const Color(0xFFBB8EF5), // 4
const Color(0xFFE874B4), // 5
];

List<Color> foregroundColors = [
const Color(0xFF2A2E31),
];

late final List<RadialButton> _children = [
  RadialIconButton(
      icon: Icons.add,
      onPressed: (_) {
        setState(() {
        });
      }).rotatedRadialButton,
  RadialIconButton(
      icon: Icons.remove,
      onPressed: (_) {
        setState(() {
        });
      }).rotatedRadialButton,
  RadialIconButton(
      icon: Icons.rotate_left,
      onPressed: (_) {
        setState(() {
        });
      }).rotatedRadialButton,
  RadialIconButton(
      icon: Icons.toggle_off,
      onPressed: (_) {
        setState(() {
        });
      }).rotatedRadialButton,
];

RadialButtonTool(
    thickness: .5,
    innerBorder: 2,
    outerBorder: 2,
    sideBorder: 2,
    clipChildren: true,
    clampCenterButton: true,
    rotateChildren: true,
    spacing: _spacing,
    foregroundColors: foregroundColors,
    backgroundColors: backgroundColors,
    centerButton: MaterialButton(
      onPressed: () {
        reset();
      },
      color: const Color(0xFF2A2E31),
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    ),
    children: _children,
  )

```
