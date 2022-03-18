import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/models/app_data.dart';
import '/models/reader.dart';
import '/pages/reader_page.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:tflite_audio/tflite_audio.dart';

import 'readers_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController beforeDetectController;
  late AnimationController afterDetectController;

  late Animation<double> beforeDetectAnimation;
  late Animation<double> afterDetectAnimation;

  late AnimationController buttonController;
  late Animation<double> buttonAnimation;

  late Stream<Map<dynamic, dynamic>> recognitionStream;

  Reader? reader;

  String result = '';
  int inferenceTime = 0;
  bool isKnown = true;

  bool isGlowing = false;

  void startRecognition() {
    recognitionStream = TfliteAudio.startAudioRecognition(
      sampleRate: 44100,
      bufferSize: 22016,
      //NOTE: This will set 70% as minimum confidence
      detectionThreshold: 0.7,
      //TODO: Check This later
      averageWindowDuration: 1500,
      // suppressionTime: 10,
      // averageWindowDuration: 10,
    );
  }

  void setUpAnimation() {
    beforeDetectController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    afterDetectController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    beforeDetectAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: beforeDetectController,
      curve: Curves.easeInOut,
    ));
    afterDetectAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: afterDetectController,
      curve: Curves.easeInOut,
    ));

    beforeDetectAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: beforeDetectController,
      curve: Curves.easeInOut,
    ));
    beforeDetectController.forward();
    buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    buttonAnimation = Tween(begin: 3.0, end: 4.0).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeInOut,
      ),
    );
    buttonController.forward();
    buttonAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        buttonController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        buttonController.forward();
      }
    });
  }

  void loadModel() {
    TfliteAudio.loadModel(
      model: 'assets/model.tflite',
      label: 'assets/labels.txt',
      inputType: 'rawAudio',
      numThreads: 10,
    );
  }

  void restart() async {
    await TfliteAudio.stopAudioRecognition();
    print('looooool');
    startRecognition();
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    setUpAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    beforeDetectController.dispose();
    afterDetectController.dispose();
    buttonController.dispose();
    TfliteAudio.stopAudioRecognition();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primary = theme.brightness == Brightness.light
        ? theme.primaryColor
        : theme.primaryColorDark;
    return Scaffold(
      floatingActionButton: Directionality(
        textDirection: TextDirection.rtl,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadersPage(),
              ),
            );
          },
          label: Text('جميع القراء'),
          icon: Icon(Icons.record_voice_over_rounded),
          // child: Icon(Icons.record_voice_over_rounded),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            FadeTransition(
              opacity: beforeDetectAnimation,
              child: Text(
                'Tap to start',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AvatarGlow(
              endRadius: 200,
              repeat: true,
              animate: isGlowing,
              glowColor: primary,
              child: GestureDetector(
                onTap: () {
                  if (!isGlowing) {
                    Vibrate.feedback(FeedbackType.medium);
                    beforeDetectController.reverse();
                    afterDetectController.forward();
                    startRecognition();
                    recognitionStream.listen((event) {
                      switch (event['recognitionResult']) {
                        case 'nasser_alqatami':
                          reader = AppData.readerList
                              .where((reader) => 'ناصر القطامي' == reader.name)
                              .first;
                          reader!.instagram =
                              'https://www.instagram.com/alqtaminasser/';
                          reader!.twitter =
                              'https://twitter.com/nasseralqtami?lang=ar';
                          reader!.youtube =
                              'https://www.youtube.com/channel/UC-AuvzIPDgBmvoDMlLhBuFQ';
                          Vibrate.feedback(FeedbackType.success);
                          result = 'ناصر القطامي';
                          inferenceTime = event["inferenceTime"];
                          print(result);
                          isKnown = true;
                          break;
                        case 'al_shatri':
                          reader = AppData.readerList
                              .where((reader) =>
                                  'شيخ أبو بكر الشاطري' == reader.name)
                              .first;
                          reader!.instagram =
                              'https://www.instagram.com/sheikhalshateri/';
                          reader!.twitter =
                              'https://twitter.com/sheikhalshateri?lang=ar';
                          reader!.youtube =
                              'https://www.youtube.com/user/noblequran2';
                          Vibrate.feedback(FeedbackType.success);
                          result = 'شاطري';
                          inferenceTime = event["inferenceTime"];
                          print(result);
                          isKnown = true;
                          break;
                        case 'abdulaziz_alzahrani':
                          reader = AppData.readerList
                              .where((reader) =>
                                  'عبدالعزيز الزهراني' == reader.name)
                              .first;
                          //TODO change links
                          reader!.instagram =
                              'https://www.instagram.com/alzhranitv/';
                          reader!.twitter =
                              'https://twitter.com/alzhranitv';
                          reader!.youtube =
                              'https://www.youtube.com/channel/UCYh95QxdA8GHTJowBuXcLNQ';
                          Vibrate.feedback(FeedbackType.success);
                          result = 'عبدالعزيز الزهراني';
                          inferenceTime = event["inferenceTime"];
                          print(result);
                          isKnown = true;
                          break;
                        case 'al_sudais':
                          reader = AppData.readerList
                              .where(
                                  (reader) => 'عبدالرحمن السديس' == reader.name)
                              .first;
                          //TODO change links
                          reader!.instagram =
                              'https://www.instagram.com/_asudais/';
                          reader!.twitter =
                              'https://twitter.com/alsudayscom?lang=ar';
                          reader!.youtube =
                              'https://www.youtube.com/channel/UCT-w0BCxz1gIfVx2VgcDlYw';
                          Vibrate.feedback(FeedbackType.success);
                          result = 'عبدالرحمن السديس';
                          inferenceTime = event["inferenceTime"];
                          print(result);
                          isKnown = true;
                          break;
                        case 'saud_alshuraim':
                          reader = AppData.readerList
                              .where((reader) => 'سعود الشريم' == reader.name)
                              .first;
                          //TODO change links
                          reader!.instagram =
                              'https://www.instagram.com/saud_shuraim/';
                          reader!.twitter =
                              'https://twitter.com/salshuraym?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor';
                          reader!.youtube =
                              'https://www.youtube.com/channel/UCGUK0a-a20ef34PI4X60SRQ';
                          Vibrate.feedback(FeedbackType.success);
                          result = 'سعود الشريم';
                          inferenceTime = event["inferenceTime"];
                          print(result);
                          isKnown = true;
                          break;
                        default:
                          Vibrate.feedback(FeedbackType.error);
                          isKnown = false;
                          print(event['recognitionResult']);
                          break;
                      }
                    }).onDone(
                      () {
                        if (isKnown)
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ReaderPage(reader: reader!),
                            ),
                          );
                        beforeDetectController.forward();
                        afterDetectController.reverse();
                        setState(() {
                          isGlowing = !isGlowing;
                        });
                      },
                    );
                  } else {
                    TfliteAudio.stopAudioRecognition();
                    beforeDetectController.forward();
                    afterDetectController.reverse();
                  }
                  setState(() {
                    isGlowing = !isGlowing;
                  });
                },
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: isGlowing ? 1.2 : 1.0).animate(
                    CurvedAnimation(
                      parent: buttonController,
                      curve: Curves.ease,
                    ),
                  ),
                  child: Material(
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: primary,
                      child: Icon(
                        Icons.search_rounded,
                        size: 90,
                        color: Colors.white,
                      ),
                      radius: 90.0,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              child: Text(
                'Please try again',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: theme.errorColor,
                ),
              ),
              visible: !isGlowing & !isKnown,
            ),
            FadeTransition(
              opacity: afterDetectAnimation,
              child: Text(
                'Detecting...',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
