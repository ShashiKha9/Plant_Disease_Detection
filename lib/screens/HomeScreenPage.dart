


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/services/Classifier.dart';
import 'package:plant_disease_detection/screens/PredictionScreenPage.dart';
import 'package:tflite/tflite.dart';

import '../models/disease_model.dart';
import '../services/disease_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../services/hive_database.dart';



class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  static const routeName = '/';


  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  String mModelPath="plant_disease_model.tflite";
  String mLabelPath="plant_labels.txt";
  String mSamplePath="automn.jpg";
  int inputSize=224;
   File? _image;
   // late Categorization _categorization;
   late ImagePicker _imagePicker;
   late Uint8List _imageBytes;
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   bool _loading=true;
   List _output=[];
  final Classifier classifier = Classifier();
  late Disease _disease;


  @override
  void dispose(){
    super.dispose();
  }

  @override


     // select between camera and gallery
     Future showOptions(BuildContext context,DiseaseService diseaseService,HiveService hiveService) async {



    showCupertinoModalPopup(
         context: context,
         builder: (context) =>
             CupertinoActionSheet(
               actions: [
                 CupertinoActionSheetAction(
                   child: Text('Photo Gallery'),
                   onPressed: () async {
                     // close the options modal

                     // get image from gallery
                     late double _confidence;

                   await   classifier.getDisease(ImageSource.gallery).then((value){
                       _disease=Disease(
                           name: value![0]["label"],
                           imagePath: classifier.imageFile.path);

                       _confidence=value[0]['confidence'];

                       print(value[0]["label"]);
                       print(value[0]["confidence"]);


                     });
                     if(_confidence>0.8){

                       diseaseService.setDiseaseValue(_disease);

                       hiveService.addDisease(_disease);





                       Navigator.restorablePushNamed(context,
                           PredictionScreen.routeName);

                       print("confidence is printing");




                     }
                     
                   },

                 ),
                 CupertinoActionSheetAction(
                   child: Text('Camera'),
                   onPressed: () {
                     // close the options modalg
                     Navigator.of(context).pop();
                     // get image from camera
                     late double _confidence;

                     classifier.getDisease(ImageSource.camera).then((value){
                       _disease=Disease(
                           name: value![0]["label"],
                           imagePath: classifier.imageFile.path);

                       _confidence=value[0]['confidence'];

                       print(value[0]["label"]);
                       print(value[0]["confidence"]);

                     });
                     if(_confidence>0.8){

                       Navigator.restorablePushNamed(context,
                           PredictionScreen.routeName);
                     }

                   },
                 ),
               ],
             ),
       );
     }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Classifier classifier = Classifier();
    // late Disease _disease;

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(onPressed:(){
          showOptions(context,Provider.of<DiseaseService>(context,listen: false),HiveService());

        },
        tooltip: 'Increment',
          shape: CircleBorder(),
        child: Image.asset("assets/automn.jpg"),
          backgroundColor: Color(0xff9FF16D),
        ),
        bottomNavigationBar:


            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),

              child: BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed:(){},
                        icon: Icon(Icons.home)),

                    IconButton(onPressed:(){},
                        icon: Icon(Icons.settings))
                  ],
                ),
                         ),
            ),


        backgroundColor: Colors.black26,
        appBar: AppBar(
          title: Text("Plant Disease"),
      
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
        height: 200,
              width: 200,
              child: Card(
                elevation: 5,
                semanticContainer: true,
      
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child:
      
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Heal your crop",style: TextStyle(color: Colors.teal[400]),),
      
                    ElevatedButton(onPressed: (){

                    },
                        child:Row(
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Take a picture"),
                          ],
                        )),
                  ],
                  ),
                ),
            ),

          _image==null && _loading?Container(
        child: Image.asset("assets/automn.jpg"),
      ):Container(
            height: 200,
            child:Image.file(_image!),
          ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>PredictionScreen()));
            }, child: Text("Second widget")),
            
           // _output!=null? Text("${_output[0]['label']}"):Container()
          ],
        ),
      )

    );
  }
}
