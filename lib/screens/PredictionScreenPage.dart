import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_disease_detection/models/Classifier.dart';
import 'package:plant_disease_detection/screens/HomeScreenPage.dart';


class PredictionScreen extends StatelessWidget {


  final File imageFile;
  PredictionScreen({required this.imageFile,});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),



            ),
              child:Column(
                children: [
                  imageFile !=null?Image.file(imageFile):Text("No image selected"),

                ],
              )


          )
        ],


      ),
    );
  }
}
