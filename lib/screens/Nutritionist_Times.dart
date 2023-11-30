import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/Nutritionist.dart';
import 'Settings.dart';

class Nutritionist_Times extends StatefulWidget {
  const Nutritionist_Times({Key? key}) : super(key: key);

  @override
  State<Nutritionist_Times> createState() => _Nutritionist_TimesState();
}

class _Nutritionist_TimesState extends State<Nutritionist_Times> {
  DateTime today = DateTime.now();
  int selectedIndex = -1;
  List<int> selectedIndices = [];
  List<Map<String, bool>> appointmentsTime = [];
  List<Map<String, dynamic>> selectedTime = [];

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
    RestAPIConector.getNutrionestAppointments(
            today, context, nutritionist.id, UserType)
        .then((responseBody) {
      setState(() {
        if (responseBody.isNotEmpty) {
          for (int i = 0;
              i < responseBody["appointmentStart_time"].length;
              i++) {
            appointmentsTime.add({
              responseBody["appointmentStart_time"][i]["appointmentStart_time"]:
                  responseBody["appointmentStart_time"][i]["available"]
            });
          }
        }
      });
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      selectedIndices.clear();
      selectedTime.clear();
      appointmentsTime.clear();
      getAppointment();
    });
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> timeParts = timeString.split(' ');
    List<String> timeComponents = timeParts[0].split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);
    if (timeParts[1] == 'PM') {
      hour += 12;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isTimeInList(String targetTime) {
    TimeOfDay targetTimeOfDay = _parseTimeOfDay(targetTime);
    return appointmentsTime.any((timeEntry) {
      String timeKey = timeEntry.keys.first;
      TimeOfDay timeOfDay = _parseTimeOfDay(timeKey);
      return timeOfDay == targetTimeOfDay;
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image(image: AssetImage('images/back.png')),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Settings(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'رجوع',
                                  style: GoogleFonts.robotoCondensed(
                                      color: Colors.deepPurple),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //-------------------------------------
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              "طرح مواعيد للمرضى",
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
                      "أوقات التواجد في تاريخ :" +
                          today.toString().split(" ")[0],
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                //---------------------------------------
                // Time Slots
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Container(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(
                        12,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isTimeInList('${index + 1}:00 PM')) {
                                (ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('هذا الموعد تم اختياره مسبقاً'),
                                    duration: Duration(seconds: 4),
                                  ),
                                ));
                              } else {
                                if (selectedIndices.contains(index)) {
                                  var selctValue =
                                      selectedIndices.indexOf(index);
                                  selectedIndices.remove(index);
                                  selectedTime.removeAt(selctValue);
                                } else {
                                  if (index < 9) {
                                    selectedTime.add({
                                      "appointmentTime": '0${index + 1}:00 PM'
                                    });
                                  } else {
                                    selectedTime.add({
                                      "appointmentTime": '${index + 1}:00 PM'
                                    });
                                  }
                                  selectedIndices.add(index);
                                }
                              }
                            });
                          },
                          child: Container(
                            height: 30, // change the height of each square here
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                              color: isTimeInList('${index + 1}:00 PM')
                                  ? Colors.black26
                                  : (selectedIndices.contains(index)
                                      ? Colors.deepPurple
                                      : Colors.transparent),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}:00 PM',
                                style: TextStyle(
                                  color: isTimeInList('${index + 1}:00 PM')
                                      ? Colors.black
                                      : (selectedIndices.contains(index)
                                          ? Colors.white
                                          : Colors.deepPurple),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //---------Button-----------------
                SizedBox(height: 10),
                //signin button
                TextButton(
                  onPressed: () {
                    RestAPIConector.NutritionistAppointmentSchedule(
                            nutritionist.token, context, today, selectedTime)
                        .then((value) => checkAppointment());

                    getAppointment();
                  },
                  child: Text(
                    '  تثبيت مواعيد اليوم المحدد ',
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم طرح المواعيد المحددة في اليوم المحدد'),
        duration: Duration(seconds: 4),
      ),
    );
    appointmentsTime.clear();
    getAppointment();
  }
}
