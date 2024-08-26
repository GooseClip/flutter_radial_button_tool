import 'package:flutter/material.dart';

extension XWidget on Widget {
  Widget get yellow => Container(color: Colors.yellow, child: this);
  Widget get green => Container(color: Colors.green, child: this);
  Widget get blue => Container(color: Colors.blue, child: this);
  Widget get red => Container(color: Colors.red, child: this);
}
