import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/screens//login_screen.dart';
import 'package:project/screens/EditInformationSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/Nutritionist.dart';
import 'ForgetPass.dart';
import 'SignUp2.dart';
import 'controller.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class EditProfileNutritionist extends StatefulWidget {
  const EditProfileNutritionist({Key? key}) : super(key: key);

  @override
  State<EditProfileNutritionist> createState() =>
      _EditProfileNutritionistState();
}

class _EditProfileNutritionistState extends State<EditProfileNutritionist> {
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
  String phone_number = "";
  String description = "";
  String experience_years = "";
  String collage = "";
  String Specialization = "";
  String Price = "";

  Map<String, dynamic> userData = {};

  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  bool UserType = true;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _nutritionistBox = Hive.box('NutritionistBox');

    setState(() {
      nutritionist = _nutritionistBox?.get('NutritionistBox');
      gender = nutritionist.gender;
    });

    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> EditInfoNutritionistFormKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: EditInfoNutritionistFormKey,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              },
                              child:
                                  Image(image: AssetImage('images/arro.png')),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0),
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
                  SizedBox(height: 5),
                  //--------------------------PROFILE PICTURE-----------------------------------------------------
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
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            validator: (value) {
                              if (value!.isEmpty) {
                                FName = value as String;
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الاسم بالشكل الصحيح ';
                              } else {
                                FName = value as String;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: nutritionist.firstName,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,

                              isCollapsed:
                                  true, // Make the OutlineInputBorder fit the full height
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
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            validator: (value) {
                              if (value!.isEmpty) {
                                LNmae = value as String;
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الاسم بالشكل الصحيح ';
                              } else {
                                LNmae = value as String;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: nutritionist.lastName,
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
                                color: Colors.white60,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: TextFormField(
                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  validator: (value) {
                                    year = value! as String;
                                  },
                                  decoration: InputDecoration(
                                    hintText: nutritionist.date_of_birth
                                        .split('-')[0],
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
                                color: Colors.white60,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: TextFormField(
                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  validator: (value) {
                                    month = value as String;
                                  },
                                  decoration: InputDecoration(
                                    hintText: nutritionist.date_of_birth
                                        .split('-')[1],
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
                                color: Colors.white60,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: TextFormField(
                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  validator: (value) {
                                    day = value as String;
                                  },
                                  decoration: InputDecoration(
                                    hintText: nutritionist.date_of_birth
                                        .split('-')[2],
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
                  //---------------------------------------------------------------
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

                  //----------------------------------------------------------------

                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'رقم الهاتف',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  //Password textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            validator: (value) {
                              phone_number = value as String;
                            },
                            decoration: InputDecoration(
                              hintText: nutritionist.phone_number == -1
                                  ? ""
                                  : nutritionist.phone_number.toString(),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,
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
                  //-----------------------------------------------
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'الجامعة ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  //Password textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            validator: (value) {
                              collage = value as String;
                            },
                            decoration: InputDecoration(
                              hintText: nutritionist.collage,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,
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
                  //-----------------------------------------------------------

                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'التخصص',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  //Password textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            validator: (value) {
                              Specialization = value as String;
                            },
                            decoration: InputDecoration(
                              hintText: nutritionist.Specialization,
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,
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
                  //----------------------
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'سنين الخبرة',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  //Password textField
                  Container(
                    padding: EdgeInsets.only(right: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'سنة',
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          //Password textField
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Container(
                                height: 50,
                                width: 120,
                                // height: 200, // set the desired height value
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: TextFormField(
                                    textDirection: TextDirection
                                        .rtl, // set text direction to right-to-left
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      experience_years = value as String;
                                    },
                                    maxLines:
                                        null, // allow the text field to expand vertically

                                    decoration: InputDecoration(
                                      hintText:
                                          nutritionist.experience_years == -1
                                              ? ""
                                              : nutritionist.experience_years
                                                  .toString(),
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      hintTextDirection: TextDirection.rtl,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.deepPurple
                                              .withOpacity(1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  //-----------------------------------------------------------
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'الوصف ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  //Password textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: TextFormField(
                          textDirection: TextDirection
                              .rtl, // set text direction to right-to-left
                          textAlign: TextAlign.right,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            description = value as String;
                          },

                          maxLines:
                              null, // allow the text field to expand vertically

                          decoration: InputDecoration(
                            hintText: nutritionist.description,
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                            hintTextDirection: TextDirection.rtl,
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
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'مبلغ حجز الموعد ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.only(right: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'شيكل',
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          //Password textField
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: TextFormField(
                                    textDirection: TextDirection
                                        .rtl, // set text direction to right-to-left
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (10 > int.parse(value!) ||
                                          int.parse(value) > 50) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                            'يجب ان يكون المبلغ بين 10 و 50 شيكل ',
                                            textAlign: TextAlign.center,
                                          )),
                                        );
                                        return '';
                                      } else {
                                        Price = value as String;
                                      }
                                    },
                                    maxLines:
                                        null, // allow the text field to expand vertically

                                    decoration: InputDecoration(
                                      hintText: nutritionist.Price == -1
                                          ? ""
                                          : nutritionist.Price.toString(),
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      hintTextDirection: TextDirection.rtl,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.deepPurple
                                              .withOpacity(1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),

                  //-----------------------------------------------------------

                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'التقيم',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  //Password textField
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        height: 50,
                        width: 50,
                        // height: 200, // set the desired height value
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            enabled: false,
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            maxLines:
                                null, // allow the text field to expand vertically
                            decoration: InputDecoration(
                              hintText: nutritionist.rating == -1
                                  ? '0'
                                  : nutritionist.rating.toString(),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              hintTextDirection: TextDirection.rtl,
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

                  //-----------------------------------------------------------
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      if (EditInfoNutritionistFormKey.currentState!
                          .validate()) {
                        RestAPIConector.updateNutritionistInformation(
                                context,
                                nutritionist.token,
                                FName == "" ? nutritionist.firstName : FName,
                                LNmae == "" ? nutritionist.lastName : LNmae,
                                year == ""
                                    ? nutritionist.date_of_birth.split('-')[0]
                                    : year,
                                month == ""
                                    ? nutritionist.date_of_birth.split('-')[1]
                                    : month,
                                day == ""
                                    ? nutritionist.date_of_birth.split('-')[2]
                                    : day,
                                phone_number == ""
                                    ? nutritionist.phone_number.toString()
                                    : phone_number,
                                collage == "" ? nutritionist.collage : collage,
                                Specialization == ""
                                    ? nutritionist.Specialization
                                    : Specialization,
                                experience_years == ""
                                    ? nutritionist.experience_years.toString()
                                    : experience_years,
                                description == ""
                                    ? nutritionist.description
                                    : description,
                                Price == ""
                                    ? nutritionist.Price.toString()
                                    : Price,
                                nutritionist.id)
                            .then((responseBody) {
                          if (responseBody.isEmpty) {
                          } else {
                            setState(() {
                              nutritionist.firstName =
                                  responseBody["user"]["first_name"];
                              nutritionist.lastName =
                                  responseBody["user"]["last_name"];
                              nutritionist.date_of_birth =
                                  responseBody["user"]["date_of_birth"];
                              nutritionist.phone_number =
                                  responseBody["phone_number"] == null
                                      ? nutritionist.phone_number
                                      : responseBody["phone_number"];
                              nutritionist.collage =
                                  responseBody["collage"] == null
                                      ? nutritionist.collage
                                      : responseBody["collage"];
                              nutritionist.Specialization =
                                  responseBody["Specialization"] == null
                                      ? nutritionist.Specialization
                                      : responseBody["Specialization"];
                              nutritionist.experience_years =
                                  responseBody["experience_years"] == null
                                      ? nutritionist.experience_years
                                      : responseBody["experience_years"];
                              nutritionist.description =
                                  responseBody["description"] == null
                                      ? nutritionist.description
                                      : responseBody["description"];
                              nutritionist.Price = responseBody["Price"] == null
                                  ? nutritionist.Price
                                  : responseBody["Price"];
                              nutritionist.rating =
                                  responseBody["rating"] == null
                                      ? nutritionist.rating
                                      : responseBody["rating"];
                            });
                          }
                        });
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
                  SizedBox(height: 15),
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
