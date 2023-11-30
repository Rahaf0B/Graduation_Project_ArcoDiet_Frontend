import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/Services/services.dart';
import 'package:project/screens/login_screen.dart';
import 'controller.dart';
import 'ForgetPass2.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  String? Email;
  final GlobalKey<FormState> ForgetPassFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: ForgetPassFormKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Image(image: AssetImage('images/arro.png')),
                        ),
                      ],
                    ),
                  ),

                  //--------------------------------------------
                  // Image
                  Image(
                    image: AssetImage('images/forgetpass.png'),
                    width: 230,
                    height: 230,
                  ),

                  SizedBox(height: 30), // Spacer

                  // Title
                  Text(
                    'لتغيير كلمة المرور الرجاء ادخال الإيميل الخاص بك',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 14,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20), // Spacer

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 50.0),
                      child: Text(
                        'الايميل',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10), // Spacer

                  // Email textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          textDirection: TextDirection
                              .rtl, // set text direction to right-to-left
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '  '
                                  '                                                ! أدخل الايميل ';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w]{2,5}')
                                .hasMatch(value!)) {
                              return '  '
                                  '                              ! أدخل الايميل بالشكل الصحيح ';
                            } else {
                              Email = value as String;
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: Image.asset('images/mail.png'),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.deepPurple.withOpacity(1.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.deepPurple.withOpacity(1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30), // Spacer

                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (ForgetPassFormKey.currentState!.validate()) {
                            RestAPIConector.sendCode(Email!, context);
                          }
                        });
                      },
                      child: Text(
                        '  ارسال رمز التحقق  ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ))),

                  SizedBox(height: 15), // Spacer
                  //----------------------------------------------------------------
                  Container(
                    width: 300,
                    child: Divider(
                      color: Colors.deepPurple,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(height: 5), // Spacer

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //----------------------------------------------------------
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'إنشاء حساب',
                          style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ),
                      //----------------------------------------------------------
                      Text('هل أنت جديد هنا؟'),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'الدخول كضيف',
                          style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                  // Image
                  // للمباعدة بين العناصر
                  SizedBox(height: 40),
                  //----------------------------------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
