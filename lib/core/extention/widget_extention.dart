import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  Widget paddingH(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  Widget paddingV(double value) {
    return Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);
  }

  Widget paddingOnly({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: this,
    );
  }

  Widget expanded([int flex = 1]) {
    return Expanded(flex: flex, child: this);
  }

  Widget centered() {
    return Center(child: this);
  }

  Widget opacity(double value) {
    return Opacity(opacity: value, child: this);
  }

  Widget onTap(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }
}
