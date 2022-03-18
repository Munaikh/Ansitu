import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/functions.dart';

Future<void> main() async {
  await getSurahList();
  await getReaderList();
  // await loadAppData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ansitu',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.balooBhaijaan2().fontFamily,
        // primaryColor: Color(0xff602FB4),
        backgroundColor: const Color(0xffFFFBFC),
        colorSchemeSeed: const Color(0xff602FB4),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.balooBhaijaan2().fontFamily,
        // primaryColor: Color(0xff602FB4),
        // backgroundColor: Color(0xffFFFBFC),
        colorSchemeSeed: const Color(0xff602FB4),
        primaryColorDark: const Color(0xff602FB4),
      ),
      home: HomePage(),
      // home: ReaderPage(reader: AppData.readerList.where((element) => '86' == element.id).first,),
    );
  }
}
