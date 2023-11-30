import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/EditInformationSetting.dart';
import 'package:project/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/User.dart';
import 'SignUp2.dart';
import 'controller.dart';

class NCPform extends StatefulWidget {
  const NCPform({Key? key}) : super(key: key);

  @override
  State<NCPform> createState() => _NCPformState();
}

class _NCPformState extends State<NCPform> {
  int selectedValue = 0;
  bool isChecked = false;
  String? gender1;
  String? gender2;
  String? gender3;
  String? gender4;
  String? gender5;
  String? gender6;
  String? gender7;

  bool _showTextField1 = false; // initialize to false
  bool _showTextField2 = false; // initialize to false
  bool _showTextField3 = false; // initialize to false
  bool _showTextField4 = false; // initialize to false
  bool _showTextField5 = false; // initialize to false
  bool _showTextField6 = false; // initialize to false

  String Q1 = "";
  String Q2 = "";
  String Q3 = "";
  String Q4 = "";
  String Q5 = "";
  String Q6 = "";
  String Q7 = "";

  List<dynamic>? NCPData;
  //String? _gender;

  Box? _userBox;
  User user = User.empty();

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
    setState(() {
      user = _userBox?.get('UserBox');
    });
    getNcpData();
    return;
  }

  void getNcpData() {
    RestAPIConector.getNCPdata(user.token).then((response) {
      if (response != null && response.isNotEmpty) {
        setState(() {
          NCPData = response;
          Q1 = response[0]["AnswerDescription"];
          Q2 = response[1]["AnswerDescription"];
          Q3 = response[2]["AnswerDescription"];
          Q4 = response[3]["AnswerDescription"];
          Q5 = response[4]["AnswerDescription"];
          Q6 = response[5]["AnswerDescription"];
          Q7 = response[6]["AnswerDescription"];
          _showTextField1 = response[0]["QuestionAnswer"];
          _showTextField2 = response[1]["QuestionAnswer"];
          _showTextField3 = response[2]["QuestionAnswer"];
          _showTextField4 = response[3]["QuestionAnswer"];
          _showTextField5 = response[4]["QuestionAnswer"];
          _showTextField6 = response[5]["QuestionAnswer"];

          gender1 = response[0]["QuestionAnswer"] == true ? 'نعم' : 'لا';
          gender2 = response[1]["QuestionAnswer"] == true ? 'نعم' : 'لا';
          gender3 = response[2]["QuestionAnswer"] == true ? 'نعم' : 'لا';
          gender4 = response[3]["QuestionAnswer"] == true ? 'نعم' : 'لا';
          gender5 = response[4]["QuestionAnswer"] == true ? 'نعم' : 'لا';
          gender6 = response[5]["QuestionAnswer"] == true ? 'نعم' : 'لا';
          gender7 = response[6]["QuestionAnswer"] == true ? 'نعم' : 'لا';
        });
      }
    });
  }

  final GlobalKey<FormState> NCPFormFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _Q1Controller = TextEditingController(text: Q1);
    TextEditingController _Q2Controller = TextEditingController(text: Q2);
    TextEditingController _Q3Controller = TextEditingController(text: Q3);
    TextEditingController _Q4Controller = TextEditingController(text: Q4);
    TextEditingController _Q5Controller = TextEditingController(text: Q5);
    TextEditingController _Q6Controller = TextEditingController(text: Q6);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: NCPFormFormKey,
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
                                builder: (context) => EditInformationSetting(),
                              ),
                            );
                          },
                          child: Image(image: AssetImage('images/arro.png')),
                        ),
                      ],
                    ),
                  ),
                  //Images
                  SvgPicture.asset('images/ncpf.svg', height: 260, width: 260),
                  SizedBox(height: 10),

                  Text(
                    'استمارة تقييم التغذية',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //------------------------------------------------------
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender1,
                                onChanged: (value) {
                                  setState(() {
                                    gender1 = value as String?;
                                    _showTextField1 =
                                        false; // set flag to false
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender1,
                                onChanged: (value) {
                                  setState(() {
                                    gender1 = value as String?;
                                    _showTextField1 = true; // set flag to true
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 65),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل تعاني من أمراض؟',
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
                  Visibility(
                    visible: _showTextField1,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                      child: TextFormField(
                        // controller: _Q1Controller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: Q1 == "" ? 'اذكر المرض' : Q1.toString(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.deepPurple.withOpacity(1.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (_showTextField1) {
                              return '                            '
                                  '                                               يرجى التعبئة';
                            }
                          } else {
                            Q1 = value as String;
                          }
                          ;
                        },
                      ),
                    ),
                  ),

                  //--------------------------------------------------------

                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender2,
                                onChanged: (value) {
                                  setState(() {
                                    gender2 = value as String?;
                                    _showTextField2 =
                                        false; // set flag to false
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender2,
                                onChanged: (value) {
                                  setState(() {
                                    gender2 = value as String?;
                                    _showTextField2 = true; // set flag to true
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 49),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل أجريت لك أي عملية؟',
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
                  Visibility(
                    visible: _showTextField2,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                      child: TextFormField(
                        // controller: _Q2Controller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: Q2 == "" ? 'أذكر العملية' : Q2,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.deepPurple.withOpacity(1.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (_showTextField2) {
                              return '                            '
                                  '                                               يرجى التعبئة';
                            }
                          } else {
                            Q2 = value as String;
                          }
                        },
                      ),
                    ),
                  ),

                  //----------------------------------------------------------------

                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender3,
                                onChanged: (value) {
                                  setState(() {
                                    gender3 = value as String?;
                                    _showTextField3 =
                                        false; // set flag to false
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender3,
                                onChanged: (value) {
                                  setState(() {
                                    gender3 = value as String?;
                                    _showTextField3 = true; // set flag to true
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل يوجد حساسية لأي نوع طعام؟',
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
                  Visibility(
                    visible: _showTextField3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                      child: TextFormField(
                          // controller: _Q3Controller,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: Q3 == "" ? 'أذكر الحساسية' : Q3,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.deepPurple.withOpacity(1.0),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (_showTextField3) {
                                return '                            '
                                    '                                               يرجى التعبئة';
                              }
                            } else {
                              Q3 = value as String;
                            }
                          }),
                    ),
                  ),

                  //----------------------------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender4,
                                onChanged: (value) {
                                  setState(() {
                                    gender4 = value as String?;
                                    _showTextField4 =
                                        false; // set flag to false
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender4,
                                onChanged: (value) {
                                  setState(() {
                                    gender4 = value as String?;
                                    _showTextField4 = true; // set flag to true
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 78),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل تستخدم أدوية؟',
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
                  Visibility(
                    visible: _showTextField4,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                      child: TextFormField(
                        // controller: _Q4Controller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: Q4 == "" ? 'أذكر الدواء' : Q4,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.deepPurple.withOpacity(1.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (_showTextField4) {
                              return '                            '
                                  '                                               يرجى التعبئة';
                            }
                          } else {
                            Q4 = value as String;
                          }
                        },
                      ),
                    ),
                  ),
                  //--------------------------------------------------------------

                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender5,
                                onChanged: (value) {
                                  setState(() {
                                    gender5 = value as String?;
                                    _showTextField5 =
                                        false; // set flag to false
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender5,
                                onChanged: (value) {
                                  setState(() {
                                    gender5 = value as String?;
                                    _showTextField5 = true; // set flag to true
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 28),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل تستخدم الأعشاب للعلاج؟',
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
                  Visibility(
                    visible: _showTextField5,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                      child: TextFormField(
                        // controller: _Q5Controller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: Q5 == "" ? 'أذكر الأعشاب' : Q5,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.deepPurple.withOpacity(1.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (_showTextField5) {
                              return '                            '
                                  '                                               يرجى التعبئة';
                            }
                          } else {
                            Q5 = value as String;
                          }
                        },
                      ),
                    ),
                  ),
                  //----------------------------------------------------------------

                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender6,
                                onChanged: (value) {
                                  setState(() {
                                    gender6 = value as String?;
                                    _showTextField6 =
                                        false; // set flag to false
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender6,
                                onChanged: (value) {
                                  setState(() {
                                    gender6 = value as String?;
                                    _showTextField6 = true; // set flag to true
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 77),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل تمارس الرياضة؟',
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
                  Visibility(
                    visible: _showTextField6,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 15, right: 15),
                      child: TextFormField(
                        // controller: _Q6Controller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: Q6 == "" ? 'أذكر نوع الرياضة ومدتها' : Q6,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.deepPurple.withOpacity(1.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (_showTextField6) {
                              return '                            '
                                  '                                               يرجى التعبئة';
                            }
                          } else {
                            Q6 = value as String;
                          }
                        },
                      ),
                    ),
                  ),

                  //------------------------------------------------------------

                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'لا',
                                groupValue: gender7,
                                onChanged: (value) {
                                  setState(() {
                                    gender7 = value as String?;
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text('نعم',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.deepPurple)),
                              Radio(
                                value: 'نعم',
                                groupValue: gender7,
                                onChanged: (value) {
                                  setState(() {
                                    gender7 = value as String?;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 99),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              'هل انت مدخن؟',
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
                  //----------------------------------------------------
                  SizedBox(height: 15),
                  //signin button
                  TextButton(
                    onPressed: () {
                      if (NCPFormFormKey.currentState!.validate()) {
                        List<String?> genderFields = [
                          gender1,
                          gender2,
                          gender3,
                          gender4,
                          gender5,
                          gender6,
                          gender7
                        ];
                        if (genderFields.any((gender) => gender == null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('الرجاء تعبئة كافة الخانات')),
                          );
                        } else {
                          RestAPIConector.PutNCPAnswer(
                                  context,
                                  user.token,
                                  gender1 == "نعم" ? true : false,
                                  gender2 == "نعم" ? true : false,
                                  gender3 == "نعم" ? true : false,
                                  gender4 == "نعم" ? true : false,
                                  gender5 == "نعم" ? true : false,
                                  gender6 == "نعم" ? true : false,
                                  gender7 == "نعم" ? true : false,
                                  Q1,
                                  Q2,
                                  Q3,
                                  Q4,
                                  Q5,
                                  Q6,
                                  Q7)
                              .then((response) {});
                        }
                      }
                    },
                    child: Text(
                      '       حفظ       ',
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
