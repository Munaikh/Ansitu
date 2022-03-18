import 'package:flutter/material.dart';
import 'package:tflite_audio/tflite_audio.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({Key? key}) : super(key: key);

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  late Stream<Map<dynamic, dynamic>> recognitionStream;

  String result = '';
  int inferenceTime = 0;
  bool isKnown = true;

  @override
  void initState() {
    super.initState();
    TfliteAudio.loadModel(
      //TODO: Change this to your own model // done
      model: 'assets/soundclassifier_with_metadata.tflite',
      label: 'assets/labels.txt',
      inputType: 'rawAudio',
    );
  }

  void startRecognition() {
    recognitionStream = TfliteAudio.startAudioRecognition(
      sampleRate: 44100,
      bufferSize: 22016,
      //NOTE: This will set 70% as minimum confidence
      detectionThreshold: 0.7,
      averageWindowDuration: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(result),
            
            ElevatedButton(
              child: Text('Start'),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              onPressed: () {
                startRecognition();
                recognitionStream.listen((event) {
                  switch (event['recognitionResult']) {
                    case 'Nasser':
                      result = 'ناصر القطامي';
                      inferenceTime = event["inferenceTime"];
                      print(result);
                      isKnown = true;
                      break;
                    case 'Shatery':
                      result = 'شاطري';
                      inferenceTime = event["inferenceTime"];
                      print(result);
                      isKnown = true;
                      break;
                    default:
                      isKnown = false;
                      break;
                  }
                }).onDone(
                  () {
                    setState(() {});
                    if (!isKnown) startRecognition();
                  },
                );
              },
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // TfliteAudio.stopAudioRecognition();
            //   },
            //   child: Text('End'),
            //   style: ElevatedButton.styleFrom(
            //       shape: StadiumBorder(), primary: Colors.red),
            // )
          ],
        ),
      ),
    );
  }
}
