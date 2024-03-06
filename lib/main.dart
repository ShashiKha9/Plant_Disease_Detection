import 'package:flutter/material.dart';
import 'package:plant_disease_detection/screens/PredictionScreenPage.dart';

import 'screens/HomeScreenPage.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: HomeScreenPage(),
    );
  }

}