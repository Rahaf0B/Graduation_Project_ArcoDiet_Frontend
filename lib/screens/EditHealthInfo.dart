import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/screens/EditInformationSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/services.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'controller.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

import 'package:flutter_svg/flutter_svg.dart';

class EditHealthInformation extends StatefulWidget {
  const EditHealthInformation({Key? key}) : super(key: key);

  @override
  State<EditHealthInformation> createState() => _EditHealthInformationState();
}

class _EditHealthInformationState extends State<EditHealthInformation> {
  List<dynamic>? allergies;
  List<dynamic>? diseases;

  String? selectedAllergiesValue;
  String? selectedDiseasesValue;
  double userWight = 0;
  double userHight = 0;
  var userAllergies = <int>[];
  var userDiseases = <int>[];
  List<String>? allergiesValue;
  List<String>? diseasesValue;
  //---------------------------------------------------
  List<String> _selectedItems = [];
  List<String> _selectedItems2 = [];

  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  bool UserType = true;

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: allergiesValue!, selectedValue: "");
      },
    );
    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  void _showMultiSelect2() async {
    final List<String>? results2 = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect2(items: diseasesValue!, selectedValue: "");
      },
    );
    // Update UI
    if (results2 != null) {
      setState(() {
        _selectedItems2 = results2;
      });
    }
  }

  @override
  void initState() {
    allergies = [];
    diseases = [];
    allergiesValue = [];
    selectedAllergiesValue = "";
    RestAPIConector.getAllergies().then((resposeBody) {
      setState(() {
        resposeBody.forEach((value) {
          allergies?.add(value);
        });
        allergiesValue = allergies
            ?.map((element) => element['allergies_name'].toString())
            .toList();
        allergiesValue?.insert(0, "لا يوجد");
        selectedAllergiesValue = allergiesValue?[0];
      });
    });

    RestAPIConector.getDiseases().then((resposeBody) {
      setState(() {
        resposeBody.forEach((value) {
          diseases?.add(value);
        });

        diseasesValue = diseases
            ?.map((element) => element['diseases_name'].toString())
            .toList();
        diseasesValue?.insert(0, "لا يوجد");
        selectedDiseasesValue = diseasesValue?[0];
      });
    });

    super.initState();
    _openBox();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _userBox = Hive.box('UserBox');
    _nutritionistBox = Hive.box('NutritionistBox');
    List<String> NoData = [];
    NoData.add("لا يوجد");
    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
        if (user.allergies != null && user.allergies.isNotEmpty) {
          _selectedItems = user.allergies;
        } else {
          _selectedItems = NoData;
        }
        if (user.diseases != null && user.diseases.isNotEmpty) {
          _selectedItems2 = user.diseases;
        } else {
          _selectedItems2 = NoData;
        }
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
        if (nutritionist.allergies != null &&
            nutritionist.allergies.isNotEmpty) {
          _selectedItems = nutritionist.allergies;
        } else {
          _selectedItems = NoData;
        }
        if (nutritionist.diseases != null && nutritionist.diseases.isNotEmpty) {
          _selectedItems2 = nutritionist.diseases;
        } else {
          _selectedItems2 = NoData;
        }
      }
    });

    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> EditHealthInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: EditHealthInfoFormKey,
            child: Center(
              child: Column(children: [
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
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          'تعديل المعلومات الصحية ',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),

                SizedBox(height: 0),
                SvgPicture.asset('images/health.svg', height: 290, width: 290),

                //--------------------------طول ووزن----------------------------

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40.0),
                    child: Text(
                      'الوزن',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(right: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'كيلوغرام',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            validator: (value) {
                              if (value!.isEmpty) {
                              } else if (!RegExp(r'^\d+$').hasMatch(value!)) {
                                return '  '
                                    '!أدخل الوزن بشكل صحيح ';
                              } else {
                                userWight = double.parse(value)!;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: UserType == true
                                  ? user.weight.toString()
                                  : (nutritionist.weight == -1
                                      ? "الوزن"
                                      : nutritionist.weight.toString()),
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
                    ],
                  ),
                ),
                SizedBox(height: 10),

                //-------------------------------------------------------------
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40.0),
                    child: Text(
                      'الطول',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(right: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'سم',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: TextFormField(
                            textDirection: TextDirection
                                .rtl, // set text direction to right-to-left
                            validator: (value) {
                              if (value!.isEmpty) {
                                // userHight=user.height;
                              } else if (!RegExp(r'^\d+$').hasMatch(value!)) {
                                return '  '
                                    '!أدخل الطول بشكل صحيح';
                              } else {
                                userHight =
                                    double.tryParse(value)!; //value as double;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: UserType == true
                                  ? user.height.toString()
                                  : (nutritionist.height == -1
                                      ? "الطول"
                                      : nutritionist.height.toString()),
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
                    ],
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // use this button to open the multi-select dialog
                      ElevatedButton(
                        onPressed: _showMultiSelect,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            'الحساسية التي تعاني منها',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      // display selected items
                      Wrap(
                        children: _selectedItems
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
                //************************************************************
                SizedBox(height: 15),
                //------------------------------
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // use this button to open the multi-select dialog
                      ElevatedButton(
                        onPressed: _showMultiSelect2,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            'الأمراض المزمنة التي تعاني منها',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      // display selected items
                      Wrap(
                        children: _selectedItems2
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                //signin button
                TextButton(
                  onPressed: () {
                    if (EditHealthInfoFormKey.currentState!.validate()) {}
                    // do something else
                    if (_selectedItems.isEmpty || _selectedItems2.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'الرجاء  الاختيار من خيارات الحساسية و الامراض')),
                      );
                    } else {
                      RestAPIConector.editHealthInformationAPI(
                              UserType == true
                                  ? user.token
                                  : nutritionist.token,
                              _selectedItems,
                              _selectedItems2,
                              userHight == 0
                                  ? (UserType == true
                                      ? user.height
                                      : nutritionist.height)
                                  : userHight,
                              userWight == 0
                                  ? (UserType == true
                                      ? user.weight
                                      : nutritionist.weight)
                                  : userWight,
                              allergiesValue,
                              diseasesValue,
                              UserType == true ? user.id : nutritionist.id)
                          .then((response) {
                        List<String> allergiesUserValue = [];
                        List<String> diseasesUserValue = [];

                        for (int i = 0;
                            i < response["allergies"]?.length;
                            i++) {
                          allergiesUserValue
                              .add(allergiesValue![response["allergies"][i]]);
                        }
                        for (int i = 0; i < response["diseases"].length; i++) {
                          diseasesUserValue
                              .add(diseasesValue![response["diseases"][i]]);
                        }
                        if (UserType == true) {
                          setState(() {
                            user.height = response["height"];
                            user.weight = response["weight"];

                            user.allergies = allergiesUserValue;
                            user.diseases = diseasesUserValue;
                          });
                        } else {
                          setState(() {
                            nutritionist.height = response["height"];
                            nutritionist.weight = response["weight"];

                            nutritionist.allergies = allergiesUserValue;
                            nutritionist.diseases = diseasesUserValue;
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تعديل المعلومات')),
                        );
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
                //-------------------------------------
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;

  final selectedValue;
  const MultiSelect(
      {Key? key, required this.items, required this.selectedValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

  List<String> userSelect = [];

  void fillselectedValue() {
    for (int i = 0; i < widget.selectedValue.length; i++) {
      _selectedItems.add(widget.items[widget.selectedValue[i]]);
    }
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار واحدة من الخيارات المدرجة')),
      );
    } else {
      Navigator.pop(context, _selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    fillselectedValue();
    return AlertDialog(
      title: const Text('اختر الحساسية  '),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('تسليم'),
        ),
      ],
    );
  }
}

class MultiSelect2 extends StatefulWidget {
  final List<String> items;

  final selectedValue;
  const MultiSelect2(
      {Key? key, required this.items, required this.selectedValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState2();
}

class _MultiSelectState2 extends State<MultiSelect2> {
  // this variable holds the selected items
  final List<String> _selectedItems2 = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems2.add(itemValue);
      } else {
        _selectedItems2.remove(itemValue);
      }
    });
  }

  void fillselectedValue() {
    for (int i = 0; i < widget.selectedValue.length; i++) {
      _selectedItems2.add(widget.items[widget.selectedValue[i]]);
    }
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    if (_selectedItems2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار واحدة من الخيارات المدرجة')),
      );
    } else {
      Navigator.pop(context, _selectedItems2);
    }
  }

  @override
  Widget build(BuildContext context) {
    fillselectedValue();
    return AlertDialog(
      title: const Text('اختر المرض '),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems2.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('تسليم'),
        ),
      ],
    );
  }
}
