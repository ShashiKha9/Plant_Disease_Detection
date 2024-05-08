


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/services/Classifier.dart';
import 'package:plant_disease_detection/screens/PredictionScreenPage.dart';
import 'package:tflite/tflite.dart';

import '../constants/constants.dart';
import '../models/disease_model.dart';
import '../services/disease_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/hive_database.dart';



class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  static const routeName = '/';


  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {

   File? _image;
   // late Categorization _categorization;
   late ImagePicker _imagePicker;
   late Uint8List _imageBytes;
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   bool _loading=true;
   List _output=[];
  final Classifier classifier = Classifier();
  late Disease _disease;
  int selectedIndex=0;
   int _bottomNavIndex=0;

   late AnimationController _hideBottomBarAnimationController;



   //list of icons
   List<IconData> iconList=[
     Icons.home,
     Icons.settings

   ];



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
                           imagePath: classifier.imageFile.path,
                          confidence:value[0]['confidence']
                       );

                       _confidence=value[0]['confidence'];

                       print(value[0]["label"]);
                       print(value[0]["confidence"]);


                     });
                     if(_confidence>0.5){

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
                           imagePath: classifier.imageFile.path,
                           confidence: value[0]['confidence']);

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
        child: SvgPicture.asset("assets/images/floatingImage.svg"),
          backgroundColor: Constants.primaryColor,
        ),
        bottomNavigationBar:


            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),

              child: AnimatedBottomNavigationBar(
                splashSpeedInMilliseconds: 200,

                splashColor: Constants.primaryColor,
                activeColor: Constants.primaryColor,
                inactiveColor: Colors.black.withOpacity(.5),
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.softEdge,

                icons: iconList,
                activeIndex: _bottomNavIndex,
                onTap: (index ) {
                  setState(() {
                    _bottomNavIndex=index;

                  });
                },

                         ),
            ),


        appBar: AppBar(
          title: Row(
            children: [
              Image.asset("assets/images/plantme2.png",height: 42,color: Colors.teal,fit: BoxFit.contain,),


                 Container(child: Text("Plant Me",style: GoogleFonts.dangrek(color: Colors.teal,fontSize: 22))),

            ],
          ),
      
        ),
        body: Column(

          children: [
            Container(
              height: 350,
              width: 350,
              child: Card(
                elevation: 5,
                semanticContainer: true,
      
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Image.asset("assets/images/plantidcard.png")
      
                ),
            ),

          SizedBox(
            height: 40,
          ),

          _image==null && _loading?

                  Container(
                    padding: EdgeInsets.all(10),
                    height: 250,


                    child: Card(


                      elevation: 3,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),




                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Select an image of the plants's leaf to view the results",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                              //

                            ],
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Icon(Icons.sunny),
                              SizedBox(
                                width: 5,
                              ),
                              Text("The image must be well lit and clear",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),

                            ],
                          ),
                        ),


                           Padding(
                             padding: const EdgeInsets.symmetric(vertical: 20),
                             child: Row(
                              children: [
                                Icon(Icons.image_not_supported),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 350,
                                  child: Text("Images other than the specific plant's leaves may lead to inaccurate results",
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,),maxLines: 2),
                                )

                              ],
                                                       ),
                           ),



                      ],


                    )
                                  ),
                  ):Container(),




           // _output!=null? Text("${_output[0]['label']}"):Container()
          ],

        ),
      )

    );
  }
}
