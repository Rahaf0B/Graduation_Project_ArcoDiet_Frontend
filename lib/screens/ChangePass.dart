import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:project/Services/services.dart';
import 'package:project/screens/EditSecurity.dart';
import 'dart:convert';
import 'package:project/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'controller.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String? Password1;
  String? Password2;
  String? oldPass;

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

  final GlobalKey<FormState> ChangePassFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: ChangePassFormKey,
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
                              builder: (context) => EditSecurityInformation(),
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
                      'كلمة المرور القديمة',
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
                                '                                          ! أدخل كلمة المرور القديمة ';
                          } else {
                            oldPass = value as String;
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
                Container(
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
                      if (ChangePassFormKey.currentState!.validate()) {
                        RestAPIConector.ChangePass(
                            UserType == true ? user.token : nutritionist.token,
                            oldPass!,
                            Password1!,
                            Password2!,
                            context);
                      }
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
