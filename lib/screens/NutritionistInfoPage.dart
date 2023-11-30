import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'NutritionistInfo.dart';
import 'Nutritionists.dart';
import 'Patients_Appointments.dart';
import 'SecPage.dart';
import 'User_Appointments.dart';

class NutritionistInfoPage extends StatefulWidget {
  final user_id;
  const NutritionistInfoPage({Key? key, required this.user_id})
      : super(key: key);
  @override
  State<NutritionistInfoPage> createState() => _NutritionistInfoScreenPage();
}

class _NutritionistInfoScreenPage extends State<NutritionistInfoPage> {
  bool UserType = true;
  Box? _userBox;
  User user = User.empty();

  String variable1 = 'لا تتوفر معلومات';
  String variable2 = 'لا يتوفر';
  String variable3 = 'تاريخ الميلاد';
  int? selectedRadio;
  Map<String, dynamic>? ReciverInfo = {};

  @override
  void initState() {
    _openBox();
    selectedRadio = 1;
    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;

    _userBox = await Hive.box('UserBox');
    setState(() {
      user = _userBox?.get('UserBox');
    });
    getNutInfo();
    return;
  }

  void getNutInfo() {
    RestAPIConector.getNutritionistInfo(widget.user_id, user.token)
        .then((responseBody) {
      setState(() {
        ReciverInfo = responseBody;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.only(left: 200), child: Text('بطاقة الأخصائي')),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0), // Horizontal padding for the whole column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'الاسم : ${ReciverInfo != null ? (ReciverInfo!.isNotEmpty ? ReciverInfo!["user"]!["username"] : "") : ""}', // Concatenate the variable value with the Arabic text
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 18,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 8), // Add some spacing between the two texts
              Text(
                'سنين الخبرة :   ${ReciverInfo != null ? (ReciverInfo!.isNotEmpty ? (ReciverInfo!["experience_years"] != null ? ReciverInfo!["experience_years"] : variable2) : "") : ""}', // Concatenate the variable value with the Arabic text
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 18,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 8), // Add some spacing between the two texts
              Text(
                'الوصف :  ${ReciverInfo != null ? (ReciverInfo!.isNotEmpty ? (ReciverInfo!["description"] != null ? ReciverInfo!["description"] : variable2) : "") : ""}', // Concatenate the variable value with the Arabic text
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 18,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 20), // Add some spacing between the two texts
              Text(
                ' _______  تقييم الأخصائي _______', // Concatenate the variable value with the Arabic text
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8), // Add some spacing between the two texts
              RadioListTile<int>(
                value: 1,
                groupValue: selectedRadio,
                onChanged: (int? value) {
                  setState(() {
                    selectedRadio = value;
                  });
                },
                title: Text("1"),
              ),
              RadioListTile<int>(
                value: 2,
                groupValue: selectedRadio,
                onChanged: (int? value) {
                  setState(() {
                    selectedRadio = value;
                  });
                },
                title: Text("2"),
              ),
              RadioListTile<int>(
                value: 3,
                groupValue: selectedRadio,
                onChanged: (int? value) {
                  setState(() {
                    selectedRadio = value;
                  });
                },
                title: Text("3"),
              ),
              RadioListTile<int>(
                value: 4,
                groupValue: selectedRadio,
                onChanged: (int? value) {
                  setState(() {
                    selectedRadio = value;
                  });
                },
                title: Text("4"),
              ),
              RadioListTile<int>(
                value: 5,
                groupValue: selectedRadio,
                onChanged: (int? value) {
                  setState(() {
                    selectedRadio = value;
                  });
                },
                title: Text("5"),
              ),
              SizedBox(
                  height:
                      16), // Add some spacing between the radio buttons and the submit button
              ElevatedButton(
                onPressed: () {
                  int rating = ReciverInfo != null
                      ? (ReciverInfo!.isNotEmpty
                          ? (ReciverInfo!["rating"] != null
                              ? ReciverInfo!["rating"]
                              : 0)
                          : 0)
                      : 0;
                  if (rating == 0) {
                    rating = selectedRadio!;
                  } else {
                    rating = ((rating + selectedRadio!) / 2).toInt();
                  }
                  RestAPIConector.ChangeNutRating(
                          user.token, widget.user_id, rating)
                      .then((value) {});
                  // Implement your submit button logic here
                },
                child: Text('تقييم'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
