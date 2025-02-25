import 'package:calculator_app/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ScreenUtilInit(
    designSize: Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: false,
    child: MaterialApp(
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
