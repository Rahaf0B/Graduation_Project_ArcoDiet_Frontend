import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/Nutritionists.dart';
import 'package:project/screens/Reservation_User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/User.dart';

class Nutritionist_Info extends StatefulWidget {
  final user_id;
  const Nutritionist_Info({Key? key, required this.user_id}) : super(key: key);

  @override
  State<Nutritionist_Info> createState() => _Nutritionist_InfoState();
}

class _Nutritionist_InfoState extends State<Nutritionist_Info> {
  String year = ' -';
  String stars = ' -';
  String bio = 'مرحبا';
  Map<String, dynamic>? Nutritionist;

  bool UserType = true;
  Box? _userBox;
  User user = User.empty();

  @override
  void initState() {
    super.initState();
    _openBox();
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
        Nutritionist = responseBody;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Nutritionist != null) {}
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Expanded(
                    child: Row(
                      children: [
                        Image(image: AssetImage('images/back.png')),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'رجوع',
                            style: GoogleFonts.robotoCondensed(
                                color: Colors.deepPurple),
                          ),
                        ),
                        //-------------------------------------
                      ],
                    ),
                  ),
                ),
                //-------------------------------------------------
                //Images
                SizedBox(height: 20),
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(50), // Image radius
                    child: Image.network(
                      RestAPIConector.getImage(RestAPIConector.URLIP +
                          (Nutritionist != null
                              ? (Nutritionist!["user"]["profile_pic"] == null
                                  ? ""
                                  : Nutritionist!["user"]["profile_pic"])
                              : "")),
                      errorBuilder: ((context, error, stackTrace) =>
                          Image.asset('images/nutritionistsapple.png')),
                      fit: BoxFit.cover,
                    ),
                  ),
                  //
                ),
                SizedBox(height: 20),
                Text(
                  'الأخصائي ' +
                      (Nutritionist != null
                          ? Nutritionist!["user"]["username"]
                          : ""),
                  style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
                SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: 400,
                    height: 106,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Nutritionist != null
                                      ? (Nutritionist!["rating"] == null
                                          ? stars
                                          : Nutritionist!["rating"].toString())
                                      : stars,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'التقييم ',
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.deepPurple,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Nutritionist != null
                                      ? (Nutritionist!["experience_years"] ==
                                              null
                                          ? year
                                          : Nutritionist!["experience_years"]
                                              .toString())
                                      : year,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'سنوات الخبرة',
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.deepPurple,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Nutritionist != null
                                      ? (Nutritionist!["Price"] == null
                                          ? year
                                          : Nutritionist!["Price"].toString())
                                      : year,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'السعر',
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.deepPurple,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        ': عن الأخصائي ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple.shade900,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40.0),
                    child: Text(
                      Nutritionist != null
                          ? (Nutritionist!["description"] == null
                              ? "لا يوجد وصف لعرضه حالياً"
                              : Nutritionist!["description"])
                          : "لا يوجد وصف لعرضه حالياً",
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 18,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),

                SizedBox(height: 120),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationUser(
                            user_id: widget.user_id,
                            price: Nutritionist != null
                                ? (Nutritionist!["Price"] == null
                                    ? -1
                                    : Nutritionist!["Price"])
                                : -1),
                      ),
                    );
                  },
                  child: Text(
                    'احجز موعدك',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
