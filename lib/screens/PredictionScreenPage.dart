import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_disease_detection/services/Classifier.dart';
import 'package:plant_disease_detection/screens/HomeScreenPage.dart';

import '../models/disease_model.dart';
import '../services/disease_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class PredictionScreen extends StatelessWidget {


  final File? imageFile;
  PredictionScreen({ this.imageFile,});
  static const routeName = '/predictionscreen';

  late double _confidence;


  @override
  Widget build(BuildContext context) {

    final _diseaseService = Provider.of<DiseaseService>(context);


    Disease _disease = _diseaseService.disease;


    return  SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 12)),
            Container(
              height: 330,
              width: 340,



              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black54)

                ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),





                            child: Image.file(File(_disease.imagePath),fit: BoxFit.cover,))),
                  ),






            Container(
              child: Text(_disease.name,style: GoogleFonts.lato(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700,),),

            ),
            Container(
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Confidence:",style: TextStyle(),),
                  SizedBox(
                    width: 5,
                  ),

                  Text(_disease.confidence.toString(),style: TextStyle(color: Colors.black),),

                ],
              )
            ),

            SizedBox(
              height: 30,
            ),

            _disease.possibleCauses !="N/A" ?
            Container(
              height: 250,
              padding: EdgeInsets.all(10),
              child: Card(
                
                elevation: 5,
                shadowColor: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Cause",style: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w600),),
                      ),


                      Text(_disease.possibleCauses,style: TextStyle(color: Colors.black54,fontSize: 14),),

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Solution",style: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w600),),
                      ),



                      Text(_disease.possibleSolution,style: TextStyle(color: Colors.black54,fontSize: 14),),

                    ],
                  ),
                ),
              ),
            ):
                Container(),

      

          ],
        ),
      ),
    );
  }
}
