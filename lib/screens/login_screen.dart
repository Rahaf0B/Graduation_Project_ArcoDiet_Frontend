import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/models/Nutritionist.dart';
import 'package:project/models/User.dart';
import 'package:project/screens/EditInformationSetting.dart';
import 'package:project/screens/EditProfileUser.dart';
import 'package:project/screens/EditSecurity.dart';
import 'package:project/screens/ForgetPass.dart';
import 'package:project/screens/SecPage.dart';
import 'package:project/screens/SignUp1.dart';

import 'package:project/Services/services.dart';
import 'package:project/screens/home.dart';
import 'ChatSystem.dart';
import 'controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? Email;
  String? Password;

  Box? _userBox;
  Box? _nutritionistBox;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  Future _openBox() async {
    _userBox = Hive.box('UserBox');
    _nutritionistBox = Hive.box('NutritionistBox');
    return;
  }

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: loginFormKey,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
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
                        //-------------------------------------
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Container(
                            child: Text(
                              "تسجيل الدخول",
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

                  //--------------------------------------------
                  //Images
                  Image.asset('images/enterpass.png', height: 250, width: 350),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
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
                                  width: 1,
                                  color: Colors.deepPurple.withOpacity(1.0)),
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

                  SizedBox(height: 10),
                  //Password textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        child: TextFormField(
                          textDirection: TextDirection
                              .rtl, // set text direction to right-to-left
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '  '
                                  '                                            ! أدخل كلمة المرور ';
                            } else {
                              Password = value as String;
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
                                  width: 1,
                                  color: Colors.deepPurple.withOpacity(1.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPass(),
                            ),
                          );
                        },
                        child: Text(
                          'هل نسيت كلمة المرور؟',
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  //signin button
                  TextButton(
                    onPressed: () {
                      if (loginFormKey.currentState!.validate()) {
                        RestAPIConector.LoginUserApi(Email!, Password!, context)
                            .then((responseBody) {
                          List<dynamic> data = responseBody;
                          if (data[0] != "") {
                            getAndSaveUserData(
                                context, data[0], data[1], data[2]);
                          }
                        });
                      }
                    },
                    child: Text(
                      'تسجيل الدخول',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurple[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  //----------------------------------------------------------------
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

                  //---------------------------------------

                  //--------------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getAndSaveUserData(BuildContext context, String token,
      bool is_reqUser, bool is_Nutritionist) async {
    final tokenPrefs = await SharedPreferences.getInstance();
    await tokenPrefs.setString('auth_token', token);
    final userTypePrefs = await SharedPreferences.getInstance();
    await userTypePrefs.setBool('user_type', is_reqUser);

    if (is_reqUser == true) {
      RestAPIConector.getUserDataAPI(token).then((responceBody) async {
        List<String> allergies = [];
        List<String> diseases = [];

        for (int i = 0; i < responceBody["user"]["allergies"].length; i++) {
          allergies.add(responceBody["user"]["allergies"][i]["allergies_name"]);
        }

        for (int i = 0; i < responceBody["user"]["diseases"].length; i++) {
          diseases.add(responceBody["user"]["diseases"][i]["diseases_name"]);
        }

        User user = User(
            id: responceBody["user"]["user_id"],
            firstName: responceBody["user"]["first_name"],
            lastName: responceBody["user"]["last_name"],
            email: responceBody["user"]["email"],
            age: responceBody["user"]["age"],
            date_of_birth: responceBody["user"]["date_of_birth"],
            gender: responceBody["user"]["gender"],
            profile_pic: responceBody["user"]["profile_pic"] == null
                ? ""
                : responceBody["user"]["profile_pic"],
            height: responceBody["user"]["height"],
            weight: responceBody["user"]["weight"],
            allergies: allergies,
            diseases: diseases,
            token: token,
            UserType: "reqUser");
        await _userBox?.put('UserBox', user);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      });
    } else if (is_Nutritionist == true) {
      RestAPIConector.getNutritionistDataAPI(token).then((responceBody) async {
        List<String> allergies = [];
        List<String> diseases = [];

        for (int i = 0; i < responceBody["user"]["allergies"].length; i++) {
          allergies.add(responceBody["user"]["allergies"][i]["allergies_name"]);
        }

        for (int i = 0; i < responceBody["user"]["diseases"].length; i++) {
          diseases.add(responceBody["user"]["diseases"][i]["diseases_name"]);
        }

        Nutritionist usernu = Nutritionist(
            id: responceBody["user"]["user_id"],
            firstName: responceBody["user"]["first_name"],
            lastName: responceBody["user"]["last_name"],
            email: responceBody["user"]["email"],
            age: responceBody["user"]["age"],
            date_of_birth: responceBody["user"]["date_of_birth"],
            gender: responceBody["user"]["gender"],
            profile_pic: responceBody["user"]["profile_pic"] == null
                ? ""
                : responceBody["user"]["profile_pic"],
            height: responceBody["user"]["height"] == null
                ? -1
                : responceBody["user"]["height"],
            weight: responceBody["user"]["weight"] == null
                ? -1
                : responceBody["user"]["weight"],
            allergies: allergies,
            diseases: diseases,
            token: token,
            UserType: "nutritionist",
            phone_number: responceBody["phone_number"] == null
                ? -1
                : responceBody["phone_number"],
            rating:
                responceBody["rating"] == null ? -1 : responceBody["rating"],
            description: responceBody["description"] == null
                ? ""
                : responceBody["description"],
            experience_years: responceBody["experience_years"] == null
                ? -1
                : responceBody["experience_years"],
            collage:
                responceBody["collage"] == null ? "" : responceBody["collage"],
            Specialization: responceBody["Specialization"] == null
                ? ""
                : responceBody["Specialization"],
            Price: responceBody["Price"] == null ? -1 : responceBody["Price"]);
        await _nutritionistBox?.put('NutritionistBox', usernu);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      });
    }
  }
}
