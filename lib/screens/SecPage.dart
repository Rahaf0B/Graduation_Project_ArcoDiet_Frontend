import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/Guest.dart';
import 'package:project/screens/login_screen.dart';

import 'SignUp1.dart';
import 'controller.dart';

class SecPage extends StatefulWidget {
  const SecPage({Key? key}) : super(key: key);

  @override
  State<SecPage> createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  @override
  void initState() {
    if (Hive.isBoxOpen('UserBox')) {
    } else {
      _openBox();
    }

    super.initState();
  }

  Future _openBox() async {
    Box _userbox = await Hive.openBox('UserBox');
    Box _nutritionistBox = await Hive.openBox('NutritionistBox');
    return;
  }

  final GlobalKey<FormState> SecPageFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: SecPageFormKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // للمباعدة بين العناصر
                  SizedBox(height: 30),

                  //Title
                  Text(
                    'اكتشف كيف يمكنك',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'تحسين صحتك ',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 30),
                  //----------------------------------------------------------------
                  //Title
                  Text(
                    ': يمكنك التمتع بالميزات الكاملة عند',
                    style: GoogleFonts.robotoCondensed(fontSize: 14),
                  ),
                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 15),
                  //----------------------------------------------------------------
                  //2button

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Text(
                            '  تسجيل الدخول  ',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Color(int.parse(
                                      "50439D".substring(0, 6),
                                      radix: 16) +
                                  0xFF000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ))),
                      SizedBox(width: 40),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp1(),
                                ));
                          },
                          child: Text(
                            '   انشاء حساب   ',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Color(int.parse(
                                      "50439D".substring(0, 6),
                                      radix: 16) +
                                  0xFF000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ))),
                    ],
                  ),
                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 15),
                  //----------------------------------------------------------------
                  //Subtitle
                  Text(
                    ' : او يمكنك استكشاف بعض الميزات عند ',
                    style: GoogleFonts.robotoCondensed(fontSize: 14),
                  ),

                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 15),
                  //1button
                  //----------------------------------------------------------------
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarcodeGuest(),
                            ));
                      },
                      child: Text(
                        '  الدخول كضيف  ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Color(
                              int.parse("655AA8".substring(0, 6), radix: 16) +
                                  0xFF000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ))),
                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 160),
                  //Image
                  Image(
                    image: AssetImage('images/log.png'),
                    width: 300,
                    height: 300,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
