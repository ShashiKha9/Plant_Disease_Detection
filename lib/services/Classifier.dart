import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Classifier {
  late File imageFile;
  late List outputs;

  Future<List?> getDisease(ImageSource imageSource) async {
    var image = await ImagePicker().pickImage(source: imageSource);
    imageFile = File(image!.path);
    await loadModel();
    var result = await classifyImage(imageFile);
    Tflite.close();
    return result;
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/plant_disease_model.tflite",
      labels: "assets/plant_labels.txt",
      numThreads: 1,
    );
  }

  Future<List?> classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    return output;
  }
}