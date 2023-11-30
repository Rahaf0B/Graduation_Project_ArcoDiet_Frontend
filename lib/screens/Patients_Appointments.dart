import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/Nutritionist.dart';
import 'Settings.dart';

class Patients_Appointments extends StatefulWidget {
  const Patients_Appointments({Key? key}) : super(key: key);

  @override
  State<Patients_Appointments> createState() => _Patients_AppointmentsState();
}

class _Patients_AppointmentsState extends State<Patients_Appointments> {
  DateTime today = DateTime.now();
  int selectedIndex = -1;
  List<int> selectedIndices = [];
  List<dynamic> appointment = [];

  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  bool UserType = true;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _nutritionistBox = Hive.box('NutritionistBox');

    setState(() {
      nutritionist = _nutritionistBox?.get('NutritionistBox');
    });
    getAppointment();
    return;
  }

  void getAppointment() {
    RestAPIConector.getNutrtionestReservation(
            today, nutritionist.token, context)
        .then((responseBody) {
      if (responseBody.isNotEmpty) {
        setState(() {
          appointment = responseBody;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'لا يوجد مواعيد في هذا التاريخ',
            textAlign: TextAlign.center,
          )),
        );
      }
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      appointment.clear();
    });
    getAppointment();
  }

  List<String> dynamicTexts = ['Text 1', 'Text 2', 'Text 3'];

  @override
  Widget build(BuildContext context) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Image(image: AssetImage('images/back.png')),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Settings()));
                            },
                            child: Text(
                              'رجوع',
                              style: GoogleFonts.robotoCondensed(
                                  color: Colors.deepPurple),
                            ),
                          ),
                        ]),
                        //-------------------------------------
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              " مواعيد المرضى",
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
                ),
                //-------------------------------------
                // Calendar
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Container(
                    child: TableCalendar(
                        locale: "en_US",
                        rowHeight: 40,
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) => isSameDay(day, today),
                        focusedDay: today,
                        firstDay: DateTime.now(),
                        lastDay: DateTime.utc(2030, 3, 14),
                        onDaySelected: _onDaySelected),
                  ),
                ),

                SizedBox(height: 2),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30.0),
                    child: Text(
                      "المواعيد في تاريخ :" + today.toString().split(" ")[0],
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                //-------------Appointments--------------------
                SizedBox(height: 30),
                (appointment != [] &&
                        appointment != null &&
                        appointment.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .end, // Align children to the right
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.center,
                              //
                              width: 300,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: appointment.length,
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      Center(
                                          child: Container(
                                              width: 160,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    20), // Adjust the border radius here
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .deepPurpleAccent
                                                        .withOpacity(
                                                            0.3), // Adjust the shadow color and opacity
                                                    spreadRadius:
                                                        5, // Adjust the spread radius
                                                    blurRadius:
                                                        7, // Adjust the blur radius
                                                    offset: Offset(0,
                                                        3), // Adjust the shadow position (x,y)
                                                  ),
                                                ],
                                              ),
                                              child: Column(children: [
                                                SizedBox(height: 10),
                                                Text(
                                                    appointment[index]["user"]),
                                                SizedBox(height: 10),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  // width: 200,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: appointment[
                                                                  index]
                                                              ["appointments"]
                                                          .length,
                                                      itemBuilder:
                                                          (context, indexs) {
                                                        return Text(appointment[index]
                                                                            [
                                                                            "appointments"]
                                                                        [indexs]
                                                                    [
                                                                    "appointmentStart_time"]
                                                                .toString() +
                                                            " - " +
                                                            appointment[index][
                                                                            "appointments"]
                                                                        [indexs]
                                                                    [
                                                                    "appointmentEnd_time"]
                                                                .toString());
                                                      }),
                                                ),
                                                SizedBox(height: 5),
                                              ]))),
                                      SizedBox(height: 30)
                                    ]);
                                  }),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                //---------------------------------------------
              ],
            ),
          ),
        ),
      ),
    );
    //--------------------------------------
  }
}
