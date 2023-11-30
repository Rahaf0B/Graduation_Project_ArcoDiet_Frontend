import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project/Services/services.dart';

import 'package:project/screens/home.dart';

import 'package:project/screens/LoginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/Nutritionist.dart';
import 'models/User.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

String token = "";
bool login = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NutritionistAdapter());

  final tokenPrefs = await SharedPreferences.getInstance();
  try {
    token = tokenPrefs.getString('auth_token')!;
    if (token != null && token != "") {
      Box _userbox = await Hive.openBox('UserBox');
      Box _nutritionistBox = await Hive.openBox('NutritionistBox');
      final userTypePrefs = await SharedPreferences.getInstance();
      bool? userType = true;
      userType = await userTypePrefs.getBool('user_type');
      if (userType == true) {
        RestAPIConector.getUserDataAPI(token).then((responceBody) async {
          RestAPIConector.FillUserData(
              token, true, false, _userbox, _nutritionistBox);
        });
      } else {
        RestAPIConector.getNutritionistDataAPI(token)
            .then((responceBody) async {
          RestAPIConector.FillUserData(
              token, false, true, _userbox, _nutritionistBox);
        });
      }

      login = true;
    } else {
      await Hive.openBox('UserBox');
      await Hive.openBox('NutritionistBox');
    }
  } catch (e) {
    await Hive.openBox('UserBox');
    await Hive.openBox('NutritionistBox');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: login ? Home() : LoginPage(),
    );
  }
}
