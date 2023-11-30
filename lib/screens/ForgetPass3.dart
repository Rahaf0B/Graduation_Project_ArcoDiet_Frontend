import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project/Services/services.dart';
import 'package:project/screens/ForgetPass.dart';
import 'dart:convert';
import 'package:project/screens/login_screen.dart';

import 'controller.dart';

class ForgetPass3 extends StatefulWidget {
  final String? Email;
  const ForgetPass3({Key? key, @required this.Email}) : super(key: key);

  @override
  State<ForgetPass3> createState() => _ForgetPass3State();
}

class _ForgetPass3State extends State<ForgetPass3> {
  String? Password1;
  String? Password2;
  final GlobalKey<FormState> ForgetPass3FormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: ForgetPass3FormKey,
            child: Column(
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
                              builder: (context) => ForgetPass(),
                            ),
                          );
                        },
                        child: Image(image: AssetImage('images/arro.png')),
                      ),
                    ],
                  ),
                ),

                //--------------------------------------------

                //Image
                Image(
                  image: AssetImage('images/forgetpass3.png'),
                  width: 230,
                  height: 230,
                ),

                SizedBox(height: 15),
                //----------------------------------------------------------------
                Text(
                  'تغيير كلمة المرور',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),
                ),
                //----------------------------------------------------------------
                // للمباعدة بين العناصر
                SizedBox(height: 15),
                //----------------------------------------------------------------
                //Email
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.0),
                    child: Text(
                      'كلمة المرور',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                // للمباعدة بين العناصر
                SizedBox(height: 10),

                //Email textField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        textDirection: TextDirection
                            .rtl, // set text direction to right-to-left
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '  '
                                '                                          ! أدخل كلمة المرور ';
                          } else if (value!.length < 6) {
                            return '  '
                                '                                          كلمة المرور يجب ان تكون على الاقل 6 خانات ';
                          } else {
                            Password1 = value as String;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: Image.asset('images/key.png'),
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
                                color: Colors.deepPurple.withOpacity(1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //----------------------------------------------------------------
                // للمباعدة بين العناصر
                SizedBox(height: 15),
                //----------------------------------------------------------------
                //Email
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.0),
                    child: Text(
                      'تأكيد كلمة المرور',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                // للمباعدة بين العناصر
                SizedBox(height: 10),

                //Email textField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        textDirection: TextDirection
                            .rtl, // set text direction to right-to-left
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '  '
                                '                                   ! أدخل تاكيد كلمة المرور ';
                          } else if (value!.length < 6) {
                            return '  '
                                '                                          كلمة المرور يجب ان تكون على الاقل 6 خانات ';
                          } else {
                            Password2 = value as String;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: Image.asset('images/key.png'),
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
                                color: Colors.deepPurple.withOpacity(1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //----------------------------------------------------------------
                // للمباعدة بين العناصر
                SizedBox(height: 30),
                //----------------------------------------------------------------
                //button
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (ForgetPass3FormKey.currentState!.validate()) {
                          RestAPIConector.resetPassword(
                              Password1!, Password2!, widget.Email!, context);
                        }
                      });
                    },
                    child: Text(
                      '  تغيير كلمة المرور  ',
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
                //----------------------------------------------------------------
                // للمباعدة بين العناصر
                SizedBox(height: 45),
                //----------------------------------------------------------------
              ],
            ),
            //),
            // ),
          ),
        ),
      ),
    );
  }
}
