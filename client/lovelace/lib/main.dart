import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lovelace/resources/storage_methods.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/main/landing_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : content = preferences.getCustomValue('content',
            defaultValue: 0,
            adapter: JsonAdapter(serializer: (value) => value));

  final Preference<dynamic> content;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final StorageMethods storageMethods = StorageMethods();
  final sharedPreferences = await StreamingSharedPreferences.instance;
  final bool isLoggedIn = json.decode(await storageMethods.read('isLoggedIn'));

  // * Enable communication through HTTPS
  ByteData data = await PlatformAssetBundle().load('assets/ca/cert.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  // * Set the device orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp(isLoggedIn: isLoggedIn)));

// AppLock(
//       builder: (arg) => MyApp(
//             data: arg,
//             key: const Key('MyApp'),
//             isLoggedIn: isLoggedIn,
//           ),
//       lockScreen: const LockScreen(key: Key('LockScreen')),
//       backgroundLockLatency: const Duration(seconds: 3),
//       enabled: false)
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final ResponsiveLayout _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  const MyApp({Key? key, required this.isLoggedIn, Object? data})
      : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ScreenCaptureEvent screenCaptureEvent = ScreenCaptureEvent();
  // final bool _isJailbroken = true;
  double blurr = 20;
  double opacity = 0.6;
  StreamSubscription<bool>? subLock;

  @override
  void initState() {
    screenCaptureEvent.watch();
    screenCaptureEvent.preventAndroidScreenShot(true);
    WidgetsBinding.instance.addObserver(this);
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // isRooted();
    screenShotRecord();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    subLock?.cancel();
    screenCaptureEvent.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) return;

    if (state == AppLifecycleState.inactive) {
      debugPrint('App in background - $state');
      // AppLock.of(context)!.showLockScreen();
    } else {
      debugPrint('App in foreground - $state');
    }
  }

  // Future<void> isRooted() async {
  //   try {
  //     bool isJailBroken = Platform.isAndroid
  //         ? await FlutterRootJailbreak.isRooted
  //         : await FlutterRootJailbreak.isJailBroken;
  //     _isJailbroken = isJailBroken;
  //   } catch (e) {
  //     debugPrint('======ERROR: isRooted======');
  //   }

  //   setState(() {});
  // }

  Future<void> screenShotRecord() async {
    bool isSecureMode = false;
    setState(() {
      isSecureMode = !isSecureMode;
    });
    // if (isSecureMode) {
    //   FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // } else {
    //   FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    // }
    debugPrint('secure mode: $isSecureMode');
  }

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
        // home: widget.isLoggedIn
        //     ? const InitBirthayScreen()
        //     : const LandingScreen());
        home: widget.isLoggedIn ? widget._userPages : const LandingScreen());
  }
}

enum Swipe { left, right, none }