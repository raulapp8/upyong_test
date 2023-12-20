import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upyong_test/start_login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upyong_test/lib/secure_storage_service.dart';
import 'package:upyong_test/interaction/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(

      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final SecureStorageService _secureStorageService = SecureStorageService();
  @override
  void initState()  {
    super.initState();

    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {

    final accessToken = await _secureStorageService.getAccessToken();

    if (accessToken != '') {
      // Use Future.delayed to wait for the current build phase to complete.
      Future.delayed(Duration.zero, () {
        // Automatically navigate to the HomeScreen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
