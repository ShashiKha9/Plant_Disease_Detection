import 'package:flutter/material.dart';
import 'package:plant_disease_detection/screens/PredictionScreenPage.dart';

import 'models/disease_model.dart';
import 'services/disease_provider.dart';
import 'screens/HomeScreenPage.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DiseaseAdapter());

  await Hive.openBox<Disease>('plant_diseases');


  runApp( MyApp());

}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<DiseaseService>(
    create: (context)=> DiseaseService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings){
        return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case PredictionScreen.routeName:
                  return  PredictionScreen();
                case HomeScreenPage.routeName:
                default:
                  return  HomeScreenPage();
              }
            });
      },
    ),
    );
  }

}