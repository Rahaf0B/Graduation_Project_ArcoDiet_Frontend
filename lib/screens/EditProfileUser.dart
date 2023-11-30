import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:project/screens/login_screen.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'EditInformationSetting.dart';
import 'ForgetPass.dart';
import 'Settings.dart';
import 'SignUp2.dart';
import 'controller.dart';
import 'package:http/http.dart' as http;

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({Key? key}) : super(key: key);

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  int selectedValue = 0;
  bool isChecked = false;
  String? gender;

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  //---------------------------------------------------
  List<String> _selectedItems = [];
  List<String> _selectedItems2 = [];

  String dropdownValue1 = 'Option 1';
  String dropdownValue2 = 'Option 1';

  String FName = "";
  String LNmae = "";
  String Email = "";
  int Age = 0;
  String day = "";
  String month = "";
  String year = "";

  Map<String, dynamic> userData = {};

  Box? _userBox;
  User user = User.empty();

  bool UserType = true;

  @override
  void initState() {
    // getUserData();

    _openBox();
    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _userBox = Hive.box('UserBox');

    setState(() {
      user = _userBox?.get('UserBox');
      gender = user.gender;

//     FName=user.firstName;
//     LNmae=user.lastName;
// day=int.parse(user.date_of_birth.split('-')[2]);
// month=int.parse(user.date_of_birth.split('-')[1]);
// year=int.parse(user.date_of_birth.split('-')[0]);
    });

    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> EditInfoUserFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: EditInfoUserFormKey,
            child: Center(
              child: Column(
                children: [
                  Row(
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
                                    builder: (context) =>
                                        EditInformationSetting(),
                                  ),
                                );
                                // }
                              },
                              child:
                                  Image(image: AssetImage('images/arro.png')),
                            ),
                          ],
                        ),
                      ),
                      //Images
                      //Images
                      Padding(
                        padding: EdgeInsets.only(left: 120.0, right: 0),
                        child: Text(
                          'تعديل معلومات الحساب ',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SvgPicture.asset('images/ProfileInterface.svg',
                      height: 300, width: 300),
                  SizedBox(height: 20),
                  //--------------------------------------------
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'الاسم الأول',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //UserName1 textField
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
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الاسم بالشكل الصحيح ';
                              } else {
                                FName = value as String;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: user.firstName,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,
                              suffixIcon: Image.asset('images/user.png'),
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

                  SizedBox(height: 10),
                  //--------------------family name --------------------------------
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'اسم العائلة',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //UserName textField
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
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الاسم بالشكل الصحيح ';
                              } else {
                                LNmae = value as String;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: user.lastName,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,
                              suffixIcon: Image.asset('images/user.png'),
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

                  //----------------------------------------------------------------
                  //Birth textField
                  SizedBox(height: 15),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'تاريخ الميلاد',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,

                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                    } else {
                                      year = value! as String;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: user.date_of_birth.split('-')[0],
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintTextDirection: TextDirection.rtl,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,

                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                    } else {
                                      month = value as String;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: user.date_of_birth.split('-')[1],
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintTextDirection: TextDirection.rtl,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,

                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                    } else {
                                      day = value as String;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: user.date_of_birth.split('-')[2],
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintTextDirection: TextDirection.rtl,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('ذكر',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'ذكر',
                                groupValue: gender,
                                onChanged: (value) {},
                              ),
                              SizedBox(width: 20),
                              Text('أنثى',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'أنثى',
                                groupValue: gender,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Text(
                              'الجنس',
                              style: GoogleFonts.robotoCondensed(
                                color: Colors.deepPurple,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //----------------------------------------------------------------
                  SizedBox(height: 10),
                  //signin button
                  TextButton(
                    onPressed: () {
                      if (EditInfoUserFormKey.currentState!.validate()) {}
                      RestAPIConector.updateUserInformation(
                              context,
                              user.token,
                              FName == "" ? user.firstName : FName,
                              LNmae == "" ? user.lastName : LNmae,
                              year == ""
                                  ? user.date_of_birth.split('-')[0]
                                  : year,
                              month == ""
                                  ? user.date_of_birth.split('-')[1]
                                  : month,
                              day == ""
                                  ? user.date_of_birth.split('-')[2]
                                  : day,
                              user.id)
                          .then((responseBody) {
                        if (responseBody.isEmpty) {
                        } else {
                          user.firstName = responseBody["user"]["first_name"];
                          user.lastName = responseBody["user"]["last_name"];
                          user.date_of_birth =
                              responseBody["user"]["date_of_birth"];
                        }
                      });
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
                  SizedBox(height: 5),

                  //-------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
