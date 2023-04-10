import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utube_downloader/pages/home.dart';
import 'package:utube_downloader/pages/start.dart';
import 'package:utube_downloader/pages/detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Utube Downloader',
        home: StartPage(),
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ));
  }
}
