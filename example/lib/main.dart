import 'dart:math';

import 'package:example/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_radial_button_tool/flutter_radial_button_tool.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Tool Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Radial Tool Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> backgroundColors = [
    const Color(0xFF5CED81), // 1
    const Color(0xFF62D5E4), // 2
    const Color(0xFFBB8EF5), // 4
    const Color(0xFFE874B4), // 5
  ];

  List<Color> foregroundColors = [
    const Color(0xFF2A2E31),
  ];

  double _spacing = 8;
  double _thickness = 0.5;
  bool _glow = true;
  bool _rotate = false;
  double _outerBorder = 10;

  void reset() {
    setState(() {
      _spacing = 8;
      _thickness = 0.5;
      _glow = true;
      _rotate = false;
      _outerBorder = 10;
    });
  }

  late final List<RadialButton> _children = [
    CustomIconButton(
        icon: Icons.add,
        onPressed: (_) {
          setState(() {
            _spacing += 4;
          });
        }).rotatedRadialButton,
    CustomIconButton(
        icon: Icons.remove,
        onPressed: (_) {
          setState(() {
            _spacing -= 4;
          });
        }).rotatedRadialButton,
    CustomIconButton(
        icon: Icons.rotate_left,
        onPressed: (_) {
          setState(() {
            _rotate = true;
          });
        }).rotatedRadialButton,
    CustomIconButton(
        icon: Icons.toggle_off,
        onPressed: (_) {
          setState(() {
            _glow = !_glow;
            _outerBorder = _glow ? 8 : 2;
          });
        }).rotatedRadialButton,
  ];

  @override
  Widget build(BuildContext context) {
    final exampleGradient = RadialGradient(
      colors: [
        Colors.transparent,
        Colors.black.withOpacity(.2),
      ],
      radius: .5,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: RadialButtonTool(
            thickness: _thickness,
            innerBorder: 2,
            outerBorder: _outerBorder,
            sideBorder: 2,
            clipChildren: true,
            clampCenterButton: true,
            rotateChildren: false,
            foregroundGradient: exampleGradient,
            glow: _glow ? 8 : 0,
            spacing: _spacing,
            foregroundColors: foregroundColors,
            // colors: const [
            //   Color(0xFF2A2E31),
            // ],
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
              .animate(
                  target: _rotate ? 1 : 0,
                  onComplete: (_) {
                    setState(() {
                      _rotate = false;
                    });
                  })
              .rotate(begin: 0, end: -1),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
