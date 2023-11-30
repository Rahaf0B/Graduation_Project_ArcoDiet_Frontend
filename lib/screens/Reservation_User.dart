import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:project/screens/Settings.dart';
import 'package:project/screens/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../models/User.dart';
import 'controller.dart';

class ReservationUser extends StatefulWidget {
  final user_id;
  final price;
  const ReservationUser({Key? key, required this.user_id, required this.price})
      : super(key: key);

  @override
  State<ReservationUser> createState() => _ReservationUserState();
}

class _ReservationUserState extends State<ReservationUser> {
  DateTime today = DateTime.now();
  List<Map<String, bool>> appointmentsTime = [];

  int selectedIndex = -1;

  Box? _userBox;
  User user = User.empty();

  bool UserType = true;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _userBox = Hive.box('UserBox');

    setState(() {
      user = _userBox?.get('UserBox');
    });
    getNutrionestAppointments();

    return;
  }

  void getNutrionestAppointments() {
    RestAPIConector.getNutrionestAppointments(
            today, context, widget.user_id, UserType)
        .then((responseBody) {
      if (responseBody.isNotEmpty) {
        setState(() {
          for (int i = 0;
              i < responseBody["appointmentStart_time"].length;
              i++) {
            appointmentsTime.add({
              responseBody["appointmentStart_time"][i]["appointmentStart_time"]:
                  responseBody["appointmentStart_time"][i]["available"]
            });
          }
        });
      }
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      final lastChoose = today;

      if (today.toString().split(" ")[0] != day.toString().split(" ")[0]) {
        today = day;
        selectedIndex = -1;
        appointmentsTime.clear();

        getNutrionestAppointments();
      }
    });
  }

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
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.only(left: 160.0),
                            child: Text(
                              "تثبيت الحجز",
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
                  padding: const EdgeInsets.all(8.0),
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

                SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40.0),
                    child: Text(
                      " الحجز في تاريخ : " + today.toString().split(" ")[0],
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 10,
                      children: List.generate(appointmentsTime.length, (index) {
                        final pastindexChoice = selectedIndex;
                        final appointmentsTimevalue = appointmentsTime[index];

                        return GestureDetector(
                          onTap: () {
                            if (appointmentsTimevalue.values
                                    .toString()
                                    .replaceAll('(', '')
                                    .replaceAll(')', '') !=
                                "false") {
                              setState(() {
                                if (selectedIndex != index) {
                                  selectedIndex = index;
                                } else {
                                  selectedIndex = -1;
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                  'هذا الموعد محجوز لا يمكنك حجزه',
                                  textAlign: TextAlign.center,
                                )),
                              );
                            }
                          },
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                              color: appointmentsTimevalue.values
                                          .toString()
                                          .replaceAll('(', '')
                                          .replaceAll(')', '') ==
                                      "false"
                                  ? Colors.black26
                                  : (selectedIndex == index
                                      ? Colors.deepPurple
                                      : Colors.transparent),
                            ),
                            child: Center(
                              child: Text(
                                appointmentsTimevalue.keys
                                    .toString()
                                    .replaceAll('(', '')
                                    .replaceAll(')', ''),
                                style: TextStyle(
                                  color: appointmentsTimevalue.values
                                              .toString()
                                              .replaceAll('(', '')
                                              .replaceAll(')', '') ==
                                          "false"
                                      ? Colors.white
                                      : selectedIndex == index
                                          ? Colors.white
                                          : Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                //---------Button-----------------
                SizedBox(height: 10),
                Visibility(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Payment(
                              today: today,
                              appointmentsTime: appointmentsTime,
                              selectedIndex: selectedIndex,
                              user_id: widget.user_id,
                              price: widget.price,
                            ),
                          ));
                    },
                    child: Text(
                      '  حجز الموعد ',
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
                  ),
                  visible: appointmentsTime.isNotEmpty,
                ),
                SizedBox(
                  height: 10,
                ),
                //--------------------------
              ],
            ),
          ),
        ),
      ),
    );
    //--------------------------------------
  }

  void checkAppointment() {
    appointmentsTime.clear();
    getNutrionestAppointments();
  }
}
