// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/ForgetPass.dart';
import 'package:project/screens/Help.dart';
import 'package:project/screens/SecPage.dart';
import 'package:project/screens/Settings.dart';
import 'package:project/screens/SignUp1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'controller.dart';

class MoreSettings extends StatefulWidget {
  const MoreSettings({Key? key}) : super(key: key);

  @override
  State<MoreSettings> createState() => _MoreSettingsState();
}

class _MoreSettingsState extends State<MoreSettings> {
  late bool _switchValue = false;

  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  bool UserType = true;
  late final notificationPrefs;

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

    setState(() {
      if (switchv == null) {
        _switchValue = false;
      } else {
        _switchValue = switchv;
      }
    });

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

  final GlobalKey<FormState> MoreSettingsFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: MoreSettingsFormKey,
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
                                builder: (context) => Settings(),
                              ),
                            );
                          },
                          child: Image(image: AssetImage('images/arro.png')),
                        ),
                      ],
                    ),
                  ),

                  //----------------------------------------------------------------
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

                  SizedBox(height: 15),
                  // button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Switch(
                          value: _switchValue == null
                              ? false
                              : _switchValue, // use _switchValue to update the value
                          onChanged: (value) async {
                            setState(() {
                              _switchValue =
                                  value; // update the value of _switchValue
                            });
                            await notificationPrefs.setBool(
                                'switchValue', _switchValue);
                          },
                        ),
                        SizedBox(width: 120),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'الاشعارات ',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Image.asset('images/notif.png'),
                      ],
                    ),
                  ),

                  //------------------------------------------------------------
                  // button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'الدولة والتوقيت ',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        //----------------------------------
                        SizedBox(width: 20),
                        Image.asset('images/trans.png'),
                      ],
                    ),
                  ),
                  //------------------------------------------------------------
                  // button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'اتصل بنا ',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        //-----------------------------------
                        SizedBox(width: 20),
                        Image.asset('images/call.png'),
                      ],
                    ),
                  ),
                  //------------------------------------------------------------
                  // button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Help(),
                              ),
                            );
                          },
                          child: Text(
                            'المساعدة و الدعم',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        //--------------------------------------------
                        SizedBox(width: 20),
                        Image.asset('images/help.png'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        TextButton(
                          onPressed: () async {
                            final tokenPrefs =
                                await SharedPreferences.getInstance();
                            await tokenPrefs.setString('auth_token', "");

                            await Hive.box('UserBox').close();
                            await Hive.box('NutritionistBox').close();
                            // Delete the Hive box data from the device
                            await Hive.deleteBoxFromDisk('NutritionistBox');
                            await Hive.deleteBoxFromDisk('UserBox');
                            RestAPIConector.LogoutAPI(
                                UserType == true
                                    ? user.token
                                    : nutritionist.token,
                                UserType == true ? user.id : nutritionist.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecPage(),
                              ),
                            );
                          },
                          child: Text(
                            'تسجيل الخروج',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        //--------------------------------------------
                        SizedBox(width: 20),
                        SvgPicture.asset('images/signout.svg'),
                      ],
                    ),
                  ),
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
