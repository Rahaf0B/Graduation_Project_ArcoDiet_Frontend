import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/screens/EditHealthInfo.dart';
import 'package:project/screens/EditProfileNutritionist.dart';
import 'package:project/screens/EditProfileUser.dart';
import 'package:project/screens/EditSecurity.dart';
import 'package:project/screens/NCPform.dart';
import 'package:project/screens/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'controller.dart';
import 'package:http/http.dart' as http;
import '../Services/services.dart';
import 'login_screen.dart';

class EditInformationSetting extends StatefulWidget {
  const EditInformationSetting({Key? key}) : super(key: key);

  @override
  State<EditInformationSetting> createState() => _EditInformationSettingState();
}

class _EditInformationSettingState extends State<EditInformationSetting> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

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

  ImageProvider<Object> getImageProvider() {
    if (_imageFile != null) {
      return FileImage(File(_imageFile!.path));
    } else {
      String imageUrl = UserType ? user.profile_pic : nutritionist.profile_pic;
      if (imageUrl == "" || imageUrl == null) {
        return Image.asset('images/person.png').image;
      }
      return Image.network(
        RestAPIConector.getImage(RestAPIConector.URLIP + imageUrl),
        errorBuilder: ((context, error, stackTrace) =>
            Image.asset('images/person.png')),
        fit: BoxFit.cover,
      ).image;
    }
  }

  final GlobalKey<FormState> EditInfoSettingFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Form(
          key: EditInfoSettingFormKey,
          child: Center(
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
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
                          // }
                        },
                        child: Image(image: AssetImage('images/arro.png')),
                      ),
                    ],
                  ),
                ),
                Container(
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

              SizedBox(height: 5),
              //--------------------------PROFILE PICTURE-----------------------------------------------------
              Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.white,
                    backgroundImage: getImageProvider(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepPurple,
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet()),
                            );
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top: 40, right: 30),
                padding: const EdgeInsets.all(10.0),
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
                                builder: (context) =>
                                    EditSecurityInformation()));
                      },
                      child: Text(
                        'الأمان و الخصوصية',
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
                    Image.asset('images/key.png'),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 0, right: 30),
                padding: const EdgeInsets.all(10.0),
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
                                builder: (context) => UserType
                                    ? EditProfileUser()
                                    : EditProfileNutritionist()));
                      },
                      child: Text(
                        'المعلومات الشخصية',
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
                    Image.asset('images/user.png'),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0, right: 30),
                padding: const EdgeInsets.all(10.0),
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
                                builder: (context) => EditHealthInformation()));
                      },
                      child: Text(
                        'المعلومات الصحية',
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
                    Image.asset('images/health.png'),
                  ],
                ),
              ),
              UserType
                  ? Container(
                      margin: EdgeInsets.only(top: 0, right: 30),
                      padding: const EdgeInsets.all(10.0),
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
                                  builder: (context) => NCPform(),
                                ),
                              );
                            },
                            child: Text(
                              'استمارة تقييم التغذية',
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
                          Image.asset(
                            'images/bag.png',
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ]),
          ),
        ),
      ),
    ));
  }

  Widget bottomSheet() {
    return Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 30,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'اختر صورة الملف الشخصي',
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    label: const Text(
                      'الكاميرا',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  TextButton.icon(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    label: const Text(
                      'الاستوديو',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                },
                label: const Text(
                  'حذف الصورة',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    print('takePhoto function called with source: $source');
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      RestAPIConector.editProfilePic(_imageFile!, user.token, user.id, user)
          .then((response) {});
    } else {
      print('No image selected.');
    }
  }
}
