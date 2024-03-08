import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_disease_detection/services/Classifier.dart';
import 'package:plant_disease_detection/screens/HomeScreenPage.dart';

import '../models/disease_model.dart';
import '../services/disease_provider.dart';
import 'package:provider/provider.dart';


class PredictionScreen extends StatelessWidget {


  final File? imageFile;
  PredictionScreen({ this.imageFile,});
  static const routeName = '/predictionscreen';

  @override
  Widget build(BuildContext context) {

    final _diseaseService = Provider.of<DiseaseService>(context);


    Disease _disease = _diseaseService.disease;


    return  Scaffold(
      body: Column(
        children: [
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),



              ),
                child:Image.file(File(_disease.imagePath)),

                  
                ),
            
            


            ),
          Container(
            child: Text(_disease.name,style: TextStyle(color: Colors.black),),
          ),

          Container(
            child: Text(_disease.possibleCauses,style: TextStyle(color: Colors.black),),
          ),
          
        ],


      ),
    );
  }
}
