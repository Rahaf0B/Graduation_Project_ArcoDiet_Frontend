import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

import 'SignUp1.dart';
import 'controller.dart';

class SecPage extends StatefulWidget {
  const SecPage({Key? key}) : super(key: key);

  @override
  State<SecPage> createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
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
                    children: [
                      SizedBox(width: 100),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              if (formKey.currentState!.validate()) {}
                            });
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
                            setState(() {
                              if (formKey.currentState!.validate()) {}
                            });
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
                        setState(() {
                          if (formKey.currentState!.validate()) {}
                        });
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
