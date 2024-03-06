


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/models/Classifier.dart';
import 'package:plant_disease_detection/screens/PredictionScreenPage.dart';
import 'package:tflite/tflite.dart';

import '../models/disease_model.dart';



class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

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
   // void initState() {
   //   super.initState();
   //   loadModels().then((value){
   //     setState(() {
   //
   //     });
   //   });
   //   // _categorization = Categorization(modelPath: mModelPath,labelPath: mLabelPath,inputSize: inputSize);
   //   // loadModel();
   //   // loadSampleImage();
   // }

   // Future<Categorization> loadModel() async {
   //   await _categorization._load;
   // }
   // Future<void> _classifyImage() async {
   //   final results = await _categorization.recognizeImage(_imageBytes);
   //
   //   if (results.isNotEmpty) {
   //     _scaffoldKey.currentState!.showSnackBar(
   //       SnackBar(
   //         content: Text("Classified as: ${results
   //             .first['label']} with confidence: ${results
   //             .first['confidence']}"),
   //       ),
   //     );
   //   }
   // }
  // Future<List?> getDisease(ImageSource imageSource) async {
  //   var image = await ImagePicker().pickImage(source: imageSource);
  //   _image = File(image!.path);
  //   await loadModels();
  //   var result = await detectImage(_image!);
  //   Tflite.close();
  //   return result;
  // }
  //
  //  loadModels() async {
  //    await Tflite.loadModel(model:"assets/plant_disease_model.tflite",labels: "assets/plant_labels.txt",numThreads: 1);
  //    print("models loading");
  //  }
  //
  //  //
  // Future<List?>detectImage(File image)async{
  //   var output= await Tflite.runModelOnImage(numResults:2,path: image.path,
  //       threshold: 0.2,imageMean: 0.0,imageStd:255.0,asynch: true);
  //
  //   setState((){
  //     _output=output!;
  //     _loading=false;
  //
  //   });
  //   print("shashi1: ${output}");
  //
  //   return output;
  //
  // }




  // getImageFromGallery() async {
  //      final pickedFile = await  ImagePicker().pickImage(
  //          source: ImageSource.gallery);
  //
  //      setState(() {
  //        if (pickedFile != null) {
  //          _image = File(pickedFile.path);
  //        }
  //      });
  //      detectImage(_image!);
  //    }
  //
  //    Future getImageFromCamera() async {
  //      final pickedFile = await ImagePicker().pickImage(
  //          source: ImageSource.camera);
  //
  //      setState(() {
  //        if (pickedFile != null) {
  //          _image = File(pickedFile.path);
  //        }
  //      });
  //      detectImage(_image!);
  //
  //    }
     // select between camera and gallery
     Future showOptions() async {
       showCupertinoModalPopup(
         context: context,
         builder: (context) =>
             CupertinoActionSheet(
               actions: [
                 CupertinoActionSheetAction(
                   child: Text('Photo Gallery'),
                   onPressed: () {
                     // close the options modal
                     Navigator.of(context).pop();

                     // get image from gallery
                     late double _confidence;

                     classifier.getDisease(ImageSource.gallery).then((value){
                       _disease=Disease(
                           name: value![0]["label"],
                           imagePath: classifier.imageFile.path);

                       _confidence=value[0]['confidence'];

                       print(value[0]["label"]);
                       print(value[0]["confidence"]);


                     });
                     if(_confidence>0.8){

                     }
                     
                   },

                 ),
                 CupertinoActionSheetAction(
                   child: Text('Camera'),
                   onPressed: () {
                     // close the options modal
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
          showOptions();

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
            // ElevatedButton(onPressed: (){
            //   Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context)=>PredictionScreen(imageFile: _image!,)));
            // }, child: Text("Second widget")),
            
           // _output!=null? Text("${_output[0]['label']}"):Container()
      
      
      
      
      
      
      
      
          ],
        ),
      )

    );
  }
}
