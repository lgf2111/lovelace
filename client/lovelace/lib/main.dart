import 'package:flutter/material.dart';
import 'package:lovelace/screens/landing/guest_landing_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Lovelace',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: whiteColor,
        primaryColor: primaryColor,
      ),
      home: const GuestLandingScreen()
    );
  }
}
