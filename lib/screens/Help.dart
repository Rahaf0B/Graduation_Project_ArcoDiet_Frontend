// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:project/screens/MoreSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'ForgetPass.dart';
import 'SecPage.dart';
import 'SignUp1.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'controller.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  List<File> images = [];
  String dropdownValue = 'إضافة منتج';
  bool showSupportField =
      false; // Flag to control the visibility of the support field

  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  bool UserType = true;
  late final notificationPrefs;
  String? ProductName;
  String? barcode;
  String? weight;
  String? message;
  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    notificationPrefs = await SharedPreferences.getInstance();
    final switchv = await notificationPrefs.getBool('switchValue');

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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        images.add(File(pickedImage.path));
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void viewImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageFullScreenPage(image: images[index]),
      ),
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        deleteImage(index);
      }
    });
  }

  final GlobalKey<FormState> HelpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _NameController = TextEditingController(
        text: UserType == true
            ? user.firstName + " " + user.lastName
            : nutritionist.firstName + " " + nutritionist.lastName);
    TextEditingController _EmailController = TextEditingController(
        text: UserType == true ? user.email : nutritionist.email);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: HelpFormKey,
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
                                    builder: (context) => MoreSettings(),
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
                        padding: const EdgeInsets.only(left: 70.0),
                        child: Text(
                          'ساعدنا في تعديل/إضافة منتج',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //--------------------------------------------
                  SizedBox(height: 10),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'الاسم',
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
                            controller: _NameController,
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '  '
                                    '                                                   ! أدخل الاسم  ';
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                             ! أدخل الاسم بالشكل الصحيح ';
                              }
                            },
                            decoration: InputDecoration(
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
                  //-------------------------------------------------------
                  SizedBox(height: 10),
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
                          controller: _EmailController,
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
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.deepPurple.withOpacity(1.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //*********************************************************

                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 50.0),
                      child: Text(
                        'نوع المساعدة',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 160.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          if (newValue == 'دعم / شكوى') {
                            showSupportField = true;
                            images.clear();
                          } else {
                            showSupportField = false;
                          }
                        });
                      },
                      items: <String>['إضافة منتج', 'تعديل منتج', 'دعم / شكوى']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors
                                  .deepPurple, // Set the text color to Deep Purple
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 10),

                  if (!showSupportField)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.only(right: 40.0),
                        child: Text(
                          'اسم المنتج(ونكهته إن وجد)',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 10),

                  if (!showSupportField)
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
                              textDirection: TextDirection.rtl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'أدخل الاسم المنتج';
                                } else {
                                  ProductName = value as String;
                                }
                              },
                              decoration: InputDecoration(
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

                  if (!showSupportField) SizedBox(height: 10),

                  if (!showSupportField)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.only(right: 40.0),
                        child: Text(
                          'وزن المنتج',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  if (!showSupportField) SizedBox(height: 10),

                  if (!showSupportField)
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
                              textDirection: TextDirection.rtl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'أدخل وزن المنتج';
                                } else {
                                  weight = value as String;
                                }
                              },
                              decoration: InputDecoration(
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

                  if (!showSupportField) SizedBox(height: 10),

                  if (!showSupportField)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.only(right: 40.0),
                        child: Text(
                          'رقم الباركود الخاص بالمنتج',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  if (!showSupportField) SizedBox(height: 10),

                  if (!showSupportField)
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
                              textDirection: TextDirection.rtl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'أدخل رقم الباركود';
                                } else {
                                  barcode = value as String;
                                }
                              },
                              decoration: InputDecoration(
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

                  if (showSupportField)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.only(right: 50.0),
                        child: Text(
                          'شكوى/دعم',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 10),

                  if (showSupportField)
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
                              textDirection: TextDirection.rtl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '                                           ! أدخل شكوى/دعم';
                                } else {
                                  message = value as String;
                                }
                              },
                              decoration: InputDecoration(
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

                  //------------------------------------------------------
                  //************************ADD PICTURE*****************************
                  if (!showSupportField) SizedBox(height: 30),
                  if (!showSupportField)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                            children: [
                              Text(
                                'إضافة صورة واضحة لجدول القيم الغذائية',
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'الخاص بالمنتج',
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.deepPurple,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: FloatingActionButton(
                            onPressed: pickImage,
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),

                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      images.length,
                      (index) => GestureDetector(
                        onTap: () => viewImage(index),
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: Image.file(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => deleteImage(index),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.deepPurple,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //------------------------------------------------------

                  SizedBox(height: 30),
                  //signin button
                  TextButton(
                    onPressed: () {
                      if (HelpFormKey.currentState!.validate()) {
                        if (dropdownValue == 'إضافة منتج' ||
                            dropdownValue == "تعديل منتج") {
                          RestAPIConector.AddEditProduct(
                              images[0],
                              ProductName!,
                              weight!,
                              barcode!,
                              UserType == true
                                  ? user.email
                                  : nutritionist.email);
                        } else {
                          RestAPIConector.HelpAndSupportAPI(
                              message!,
                              UserType == true
                                  ? user.email
                                  : nutritionist.email);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                            'تم الأرسال',
                            textAlign: TextAlign.center,
                          )),
                        );
                      }
                    },
                    child: Text(
                      '          إرسال          ',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 18,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//**************************************************************************
class ImageFullScreenPage extends StatelessWidget {
  final File image;

  const ImageFullScreenPage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}
