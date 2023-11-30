// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/ChatSystem.dart';
import 'package:project/screens/Patients_Appointments.dart';
import 'package:project/screens/User_Appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/services.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'CalendarScreen.dart';
import 'ForgetPass.dart';
import 'HomePage.dart';
import 'Massages.dart';
import 'SecPage.dart';
import 'Settings.dart';
import 'SignUp1.dart';

import 'Nutritionists.dart';
import 'controller.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    CalendarScreen(),
    MyMessagingApp(),
  ];
// ChatScreen(),
  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;
  bool UserType = true;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _userBox = await Hive.box('UserBox');
    _nutritionistBox = await Hive.box('NutritionistBox');
    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(children: [
                          Container(
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Text('👋 مرحبا'),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(user.firstName == ""
                                ? nutritionist.firstName
                                : user.firstName),
                          )
                        ]),
                      ),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(30), // Image radius
                          child: Image.network(
                            RestAPIConector.getImage(RestAPIConector.URLIP +
                                (UserType
                                    ? user.profile_pic
                                    : nutritionist.profile_pic)),
                            errorBuilder: ((context, error, stackTrace) =>
                                Image.asset('images/imgprofile.png')),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('إذا كانت الحمية صحيحة، لا حاجة للأدوية'),
            ],
          ),
          toolbarHeight: 170,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft:
                  Radius.circular(90), // set the radius for bottom-left corner
              bottomRight:
                  Radius.circular(90), // set the radius for bottom-right corner
            ),
          ),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'التقويم',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'الرسائل',
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('الرسائل'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('الملف الشخصي'),
    );
  }
}
