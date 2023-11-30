import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/screens/ChangePass.dart';
import 'package:project/screens/EditInformationSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'controller.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';
import '../Services/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

class EditSecurityInformation extends StatefulWidget {
  const EditSecurityInformation({Key? key}) : super(key: key);

  @override
  State<EditSecurityInformation> createState() =>
      _EditSecurityInformationState();
}

class _EditSecurityInformationState extends State<EditSecurityInformation> {
  var Email;

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
    _userBox = Hive.box('UserBox');
    _nutritionistBox = Hive.box('NutritionistBox');

    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
      }
    });

    return;
  }

  final GlobalKey<FormState> EditSecurityFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: EditSecurityFormKey,
            child: Center(
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditInformationSetting(),
                                  ),
                                );
                              },
                              child:
                                  Image(image: AssetImage('images/arro.png')),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          'تعديل معلومات الحساب ',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),

                SizedBox(height: 20),
                SvgPicture.asset('images/editsec.svg', height: 250, width: 290),
                SizedBox(height: 10),
                //--------------------family name --------------------------------
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40.0),
                    child: Text(
                      'الأيميل',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
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
                            hintText: "email",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                            hintTextDirection: TextDirection.rtl,
                            suffixIcon: Image.asset('images/mail.png'),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.deepPurple.withOpacity(1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                //signin button
                Container(
                  width: 350,

                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePass(),
                        ),
                      );
                    },
                    child: Text(
                      '        تغير كلمة المرور        ',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurple[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  //-------------------------------------
                ),

                SizedBox(height: 100),
                //signin button
                TextButton(
                  onPressed: () {
                    if (EditSecurityFormKey.currentState!.validate()) {
                      RestAPIConector.editEmail(
                          Email, user, nutritionist, UserType, context);
                    }
                  },
                  child: Text(
                    '        حفظ        ',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                //-------------------------------------
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
