// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project/models/Nutritionist.dart';
import 'package:project/screens/EditInformationSetting.dart';
import 'package:project/screens/EditProfileNutritionist.dart';
import 'package:project/screens/EditProfileUser.dart';
import 'package:project/screens/FavoritProducts.dart';
import 'package:project/screens/Favoritenutritionists.dart';
import 'package:project/screens/ForgetPass.dart';
import 'package:project/screens/Nutritionist_Times.dart';
import 'package:project/screens/Patients_Appointments.dart';
import 'package:project/screens/Reservation_User.dart';
import 'package:project/screens/SecPage.dart';
import 'package:project/screens/SignUp1.dart';
import 'package:project/screens/User_Appointments.dart';
import 'package:project/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/User.dart';
import 'MoreSettings.dart';
import 'controller.dart';
import 'home.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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

  final GlobalKey<FormState> SettingsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: SettingsFormKey,
            child: Center(
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
                                builder: (context) => Home(),
                              ),
                            );
                          },
                          child: Image(image: AssetImage('images/arro.png')),
                        ),
                      ],
                    ),
                  ),
                  //--------------------------------------------

                  Container(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(40), // Image radius
                          child: Image.network(
                            RestAPIConector.getImage(RestAPIConector.URLIP +
                                (UserType
                                    ? user.profile_pic
                                    : nutritionist.profile_pic)),
                            errorBuilder: ((context, error, stackTrace) =>
                                Image.asset('images/imgprofile.png')),
                            fit: BoxFit.cover,
                          ),
                        ),
                        //
                      ),
                    ),
                  ),
                  //----------------------------------------------------------------

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditInformationSetting()));
                      },
                      child: Text(
                        'تعديل معلومات الحساب',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        minimumSize: Size(double.infinity,
                            50), // set minimumSize to a wider value
                      ),
                    ),
                  ),

                  //------------------------------------------------------------
                  // button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoriteProducts()));
                      },
                      child: Text(
                        'المنتجات المفضلة',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        minimumSize: Size(double.infinity,
                            50), // set minimumSize to a wider value
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  // button
                  Visibility(
                    visible: UserType,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Favoritenutritionists()));
                        },
                        child: Text(
                          'الاخصائيون المفضلون ',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side:
                                BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                          minimumSize: Size(double.infinity,
                              50), // set minimumSize to a wider value
                        ),
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  // button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        UserType == true
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => User_Appointments(),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Patients_Appointments(),
                                ),
                              );
                      },
                      child: Text(
                        'جدول المواعيد',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        minimumSize: Size(double.infinity,
                            50), // set minimumSize to a wider value
                      ),
                    ),
                  ),
                  //------------------------------------------------------------
                  //
                  // button

                  UserType == true
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Nutritionist_Times(),
                                ),
                              );
                            },
                            child: Text(
                              'اضافة مواعيد',
                              style: GoogleFonts.robotoCondensed(
                                color: Colors.deepPurple,
                                fontSize: 14,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.deepPurple, width: 2),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreSettings(),
                          ),
                        );
                      },
                      child: Text(
                        'إعدادت أخرى',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),

                  //Images
                  SizedBox(
                    height: 60,
                  ),
                  Image.asset('images/set.png'),
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
