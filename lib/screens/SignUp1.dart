import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/SecPage.dart';
import 'package:project/screens/login_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project/models/User.dart';

import '../Services/services.dart';
import 'SignUp2.dart';
import 'controller.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({Key? key}) : super(key: key);

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  int selectedValue = 0;
  bool isChecked = false;
  String? gender;

  String? Email;
  String? Fname;
  String? Lname;
  String? day;
  String? month;
  String? year;
  String? Password;

  Box? _userBox;
  User user = User.empty();

  bool UserType = true;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  Future _openBox() async {
    _userBox = Hive.box('UserBox');

    setState(() {
      user = _userBox?.get('UserBox');
    });

    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> Signup1FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: Signup1FormKey,
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.only(
                                    right: 0.0, left: 10, top: 5),
                                child: Row(children: [
                                  Image(image: AssetImage('images/back.png')),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SecPage(),
                                          ));
                                    },
                                    child: Text(
                                      'رجوع',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Colors.deepPurple),
                                    ),
                                  )
                                ])),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Container(
                                padding: EdgeInsets.only(
                                    right: 0.0, left: 150, top: 10),
                                child: Text(
                                  " انشاء حساب",
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.deepPurple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //--------------------------------------------
                  Container(
                    padding: EdgeInsets.only(left: 0),
                    child: SvgPicture.asset('images/imgcreateuser.svg',
                        height: 250, width: 250),
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,

                            validator: (value) {
                              if (value!.isEmpty) {
                                return '  '
                                    '                                         ! أدخل الاسم الأول ';
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الاسم بالشكل الصحيح ';
                              } else {
                                Fname = value as String?;
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: Image.asset('images/user.png'),
                              hintText: "الاسم الأول",
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
                    child: Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '  '
                                    '                                         ! أدخل اسم العائلة ';
                              } else if (!RegExp(r'^[a-z A-Z أ-ي]+$')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الاسم بالشكل الصحيح ';
                              } else {
                                Lname = value as String?;
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: Image.asset('images/user.png'),
                              hintText: "اسم العائلة",
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
                  //----------------------------------------------------------------
                  //Email textField
                  SizedBox(height: 5),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: EdgeInsets.only(right: 40.0),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '  '
                                    '                                               ! أدخل الايميل ';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,5}')
                                  .hasMatch(value!)) {
                                return '  '
                                    '                              ! أدخل الايميل بالشكل الصحيح ';
                              } else {
                                Email = value as String?;
                              }
                            },

                            decoration: InputDecoration(
                              suffixIcon: Image.asset('images/mail.png'),
                              hintText: "الإيميل",
                              hintStyle: TextStyle(),
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
                    child: Container(
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Container(
                              margin: EdgeInsets.only(right: 0),
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white60,
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
                                      year = value as String?;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "السنة",
                                    hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
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
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white60,
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
                                      month = value as String?;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "الشهر",
                                    hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
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
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white60,
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
                                      day = value as String?;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "اليوم",
                                    hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                    hintTextDirection: TextDirection.rtl,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
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
                  //------------------------------------------------------
                  SizedBox(height: 15),
                  Container(
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
                                onChanged: (value) {
                                  setState(() {
                                    gender = value as String?;
                                  });
                                },
                              ),
                              SizedBox(width: 20),
                              Text('أنثى',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'أنثى',
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value as String?;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
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
                    child: Container(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'كلمة المرور',
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
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '  '
                                    '                                         ! أدخل كلمة المرور ';
                              } else if (value!.length < 6) {
                                return '  '
                                    '                                          كلمة المرور يجب ان تكون على الاقل 6 خانات ';
                              } else {
                                Password = value as String?;
                              }
                            },
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 0),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Container(
                          padding: EdgeInsets.only(right: 40.0),
                          child: Text(
                            ' أوافق على شروط الخصوصية',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.deepPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  //signin button
                  TextButton(
                    onPressed: () {
                      if (Signup1FormKey.currentState!.validate()) {
                        if (!isChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('الرجاء تعبئة كافة الخانات')),
                          );
                        } else if (gender == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('الرجاء تعبئة كافة الخانات')),
                          );
                        } else {
                          RestAPIConector.RegisterUserAPI(
                                  Fname!,
                                  Lname!,
                                  Email!,
                                  year!,
                                  month!,
                                  day!,
                                  gender!,
                                  Password!,
                                  context)
                              .then((responseBody) {
                            if (responseBody != {} &&
                                responseBody != null &&
                                responseBody.isNotEmpty) {
                              createUser(responseBody);
                            }
                          });
                        }
                      }
                    },
                    child: Text(
                      '  انشاء حساب  ',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(
                          int.parse("50439D".substring(0, 6), radix: 16) +
                              0xFF000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  //-------------------------------------
                  Container(
                    width: 300,
                    child: Divider(
                      color: Colors.deepPurple,
                      thickness: 1,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //----------------------------------------------------------
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ),
                      //----------------------------------------------------------
                      Text('هل لديك حساب؟'),
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
                  //-------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUser(Map<String, dynamic> responseBody) async {
    User user = User(
        id: responseBody["user"]["user_id"],
        firstName: responseBody["user"]["first_name"],
        lastName: responseBody["user"]["last_name"],
        email: responseBody["user"]["email"],
        age: responseBody["user"]["age"],
        date_of_birth: responseBody["user"]["date_of_birth"],
        gender: responseBody["user"]["gender"],
        profile_pic: responseBody["user"]["profile_pic"] == null
            ? ""
            : responseBody["user"]["profile_pic"],
        height: 0,
        weight: 0,
        allergies: [],
        diseases: [],
        token: responseBody["user"]["token"],
        UserType: "reqUser");
    await _userBox?.put('UserBox', user);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUp2(),
        ));
  }
}
