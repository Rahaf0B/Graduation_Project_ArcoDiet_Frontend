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

class UserInfoPage extends StatefulWidget {
  final user_id;
  const UserInfoPage({Key? key, required this.user_id}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoScreenPage();
}

class _UserInfoScreenPage extends State<UserInfoPage> {
  String variable1 =
      'لا تتوفر معلومات'; // Replace with your actual variable value
  String variable2 = 'لا يتوفر'; // Replace with your actual variable value

  bool UserType = true;

  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  List<dynamic> UserData = [];
  @override
  void initState() {
    _openBox();
    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;

    _nutritionistBox = await Hive.box('NutritionistBox');
    setState(() {
      nutritionist = _nutritionistBox?.get('NutritionistBox');
    });
    getUserData();
  }

  void getUserData() {
    RestAPIConector.getUserDataChat(nutritionist.token, widget.user_id)
        .then((responceBody) {
      setState(() {
        UserData = responceBody;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.only(left: 200), child: Text('بطاقة المريض')),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0), // Horizontal padding for the whole column
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الاسم : ${UserData != null ? (UserData.isNotEmpty ? UserData[0]!["user"]!["username"] : "") : ""}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'الجنس :   ${UserData.isNotEmpty ? UserData[0]["user"]["gender"] : ""}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'تاريخ الميلاد :  ${UserData.isNotEmpty ? UserData[0]["user"]["date_of_birth"] : ""}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'الوزن :  ${UserData.isNotEmpty ? UserData[0]["user"]["weight"] : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'الطول :  ${UserData.isNotEmpty ? UserData[0]["user"]["height"] : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  getAllergiesDynamicText(), // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  getDiseasesDynamicText(), // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'أجرى عملية ؟  ${UserData.isNotEmpty ? (UserData[1].isNotEmpty ? (UserData[1][1]["QuestionAnswer"] == true ? UserData[1][1]["AnswerDescription"] : "لا يوجد") : "لا يوجد") : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),

                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'أدوية مستخدمة :  ${UserData.isNotEmpty ? (UserData[1].isNotEmpty ? (UserData[1][3]["QuestionAnswer"] == true ? UserData[1][3]["AnswerDescription"] : "لا يوجد") : "لا يوجد") : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'يستخدم الأعشاب للعلاج؟:  ${UserData.isNotEmpty ? (UserData[1].isNotEmpty ? (UserData[1][4]["QuestionAnswer"] == true ? UserData[1][4]["AnswerDescription"] : "لا يوجد") : "لا يوجد") : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8),
                Text(
                  'يمارس الرياضة ؟:  ${UserData.isNotEmpty ? (UserData[1].isNotEmpty ? (UserData[1][5]["QuestionAnswer"] == true ? UserData[1][5]["AnswerDescription"] : "لا يوجد") : "لا يوجد") : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
                Text(
                  'مدخن ؟  ${UserData.isNotEmpty ? (UserData[1].isNotEmpty ? (UserData[1][1]["QuestionAnswer"] == true ? "نعم" : "لا ") : "لا يوجد") : variable2}', // Concatenate the variable value with the Arabic text
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8), // Add some spacing between the two texts
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getDiseasesDynamicText() {
    String dynamicText = 'نوع المرض';
    dynamicText = dynamicText + ":\n";
    if (UserData.isNotEmpty) {
      if (UserData[0]!["user"]!["diseases"] != [] &&
          UserData[0]["user"]["diseases"] != null) {
        for (int i = 0; i < UserData[0]!["user"]!["diseases"]!.length; i++) {
          dynamicText += "       " +
              '${UserData[0]!["user"]!["diseases"]![i]!["diseases_name"]} \n'; // Example logic, you can change this based on your requirements
        }
      }
    }
    return dynamicText;
  }

  String getAllergiesDynamicText() {
    String dynamicText = 'نوع الحساسية';
    dynamicText = dynamicText + ":\n";

    if (UserData.isNotEmpty) {
      if (UserData[0]!["user"]!["allergies"] != [] &&
          UserData[0]!["user"]!["allergies"] != null) {
        for (int i = 0; i < UserData[0]!["user"]!["allergies"]!.length; i++) {
          dynamicText += "       " +
              '${UserData[0]!["user"]!["allergies"]![i]!["allergies_name"]!} \n'; // Example logic, you can change this based on your requirements
        }
      } else {
        dynamicText + variable2;
      }
    }

    return dynamicText;
  }
}
