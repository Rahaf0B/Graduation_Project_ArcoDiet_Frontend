import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/User.dart';
import 'SignUp1.dart';
import 'controller.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key}) : super(key: key);

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  List<String> _selectedItems = [];
  List<String> _selectedItems2 = [];
  String dropdownValue1 = 'Option 1';
  String dropdownValue2 = 'Option 1';

  List<dynamic>? allergies;
  List<dynamic>? diseases;

  String? selectedAllergiesValue;
  String? selectedDiseasesValue;
  double? userWight;
  double? userHight;
  var userAllergies = <int>[];
  var userDiseases = <int>[];
  List<String>? allergiesValue;
  List<String>? diseasesValue;

  Box? _userBox;
  User user = User.empty();

  @override
  void initState() {
    _openBox();

    super.initState();
  }

  void getAlergDess() {
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
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    await userTypePrefs.setBool('user_type', true);
    _userBox = await Hive.box('UserBox');

    final tokenPrefs = await SharedPreferences.getInstance();

    setState(() {
      user = _userBox?.get('UserBox');
    });
    await tokenPrefs.setString('auth_token', user.token);
    getAlergDess();
    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: allergiesValue!);
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
        return MultiSelect2(items: diseasesValue!);
      },
    );
    // Update UI
    if (results2 != null) {
      setState(() {
        _selectedItems2 = results2;
      });
    }
  }

  final GlobalKey<FormState> Signup2FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: Signup2FormKey,
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp1(),
                              ),
                            );
                          },
                          child: Image(image: AssetImage('images/arro.png')),
                        ),
                      ],
                    ),
                  ),

                  //--------------------------------------------

                  //Images
                  Image.asset('images/signup2.png', height: 230, width: 350),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: EdgeInsets.only(right: 50.0),
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

                  //Email textField
                  Container(
                    padding: EdgeInsets.only(right: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 115.0),
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
                          width: 135,
                          height: 60,
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
                                  return '  '
                                      '   ! أدخل الوزن ';
                                } else if (!RegExp(r'^\d+$').hasMatch(value!)) {
                                  return '  '
                                      '!أدخل الوزن بشكل صحيح ';
                                } else {
                                  userWight = double.parse(value);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'مثل : 50',
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
                      ],
                    ),
                  ),

                  SizedBox(height: 5),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: EdgeInsets.only(right: 50.0),
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
                  Container(
                    padding: EdgeInsets.only(right: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 145.0),
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
                          width: 135,
                          height: 60,
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
                                  return '  '
                                      '   ! أدخل الطول ';
                                } else if (!RegExp(r'^\d+$').hasMatch(value!)) {
                                  return '  '
                                      '!أدخل الطول بشكل صحيح';
                                } else {
                                  userHight = double.parse(value);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'مثل : 50',
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
                      ],
                    ),
                  ),

                  SizedBox(height: 5),

                  //------------------------

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // use this button to open the multi-select dialog
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepPurple),
                          ),
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

                  //------------------------
                  SizedBox(height: 0),
                  //------------------------------
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // use this button to open the multi-select dialog
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepPurple),
                          ),
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
                  //------------------------------
                  SizedBox(height: 15),
                  //signin button
                  TextButton(
                    onPressed: () {
                      if (Signup2FormKey.currentState!.validate()) {
                        // do something else
                        if (_selectedItems.isEmpty || _selectedItems2.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('الرجاء تعبئة كافة الخانات')),
                          );
                        } else {
                          User user = _userBox?.get('UserBox');

                          RestAPIConector.addUserInformationAPI(
                                  user.token,
                                  _selectedItems,
                                  _selectedItems2,
                                  userHight,
                                  userWight,
                                  allergiesValue,
                                  diseasesValue,
                                  user.id)
                              .then((response) {
                            List<String> allergiesUserValue = [];
                            List<String> diseasesUserValue = [];

                            for (int i = 0;
                                i < response["allergies"]?.length;
                                i++) {
                              allergiesUserValue.add(
                                  allergiesValue![response["allergies"][i]]);
                            }
                            for (int i = 0;
                                i < response["diseases"].length;
                                i++) {
                              diseasesUserValue
                                  .add(diseasesValue![response["diseases"][i]]);
                            }

                            user.height = response["height"];
                            user.weight = response["weight"];

                            user.allergies = allergiesUserValue;
                            user.diseases = diseasesUserValue;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ),
                            );
                          });
                        }
                      }
                    },
                    child: Text(
                      'استمر',
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
                  )

                  //---------------------------------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

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
  const MultiSelect2({Key? key, required this.items}) : super(key: key);

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
