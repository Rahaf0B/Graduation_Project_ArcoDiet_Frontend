import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/ChatSystem.dart';
import 'package:project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/Services/services.dart';
import 'package:project/models/Nutritionist.dart';
import 'package:project/models/User.dart';

class MyMessagingApp extends StatefulWidget {
  const MyMessagingApp({Key? key}) : super(key: key);

  @override
  State<MyMessagingApp> createState() => _OuterPageState();
}

class _OuterPageState extends State<MyMessagingApp> {
  List<dynamic> appointment = [];

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
    _userBox = await Hive.box('UserBox');
    _nutritionistBox = await Hive.box('NutritionistBox');
    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
      }
    });
    if (UserType == true) {
      getChat();
    } else {
      getNuChat();
    }
    return;
  }

  void getNuChat() {
    RestAPIConector.getNutrtionestChat(nutritionist.token, context)
        .then((responseBody) {
      if (responseBody.isNotEmpty) {
        setState(() {
          appointment = responseBody;
        });
      }
    });
  }

  void getChat() {
    RestAPIConector.getUserChatNutrtionest(user.token, context)
        .then((responseBody) {
      if (responseBody.isNotEmpty) {
        setState(() {
          appointment = responseBody;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(10, 120),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 140,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFF9489e3),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: AppBar(
                          title: Container(
                            padding: EdgeInsets.only(bottom: 0),
                            child: Center(child: Text("الرسائل")),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),

                        // Add other AppBar properties as needed
                      )),
                ],
              ),
            ],
          )),
      body: ListView.builder(
        itemCount: appointment.length,
        itemBuilder: (context, index) {
          return Center(
              child: Card(
            elevation:
                4, // Adjust the elevation value as needed for the desired shadow intensity
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40), // Add rounded corners
            ),
            child: ListTile(
              title: Text(
                UserType == true
                    ? appointment[index]['nutritionist']!
                    : appointment[index]["Reservationuser"]["user"]["username"],
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              trailing: CircleAvatar(
                backgroundColor: Colors.transparent,
                // Replace this with the actual image URL or image asset
                child: Image.network(
                  RestAPIConector.getImage(RestAPIConector.URLIP +
                      (UserType == true
                          ? appointment[index]["appointments"][0]['profile_pic']
                          : (appointment[index]["Reservationuser"]["user"]
                                      ["profile_pic"] ==
                                  null
                              ? ""
                              : appointment[index]["Reservationuser"]["user"]
                                  ["profile_pic"]))),
                  errorBuilder: ((context, error, stackTrace) =>
                      Image.asset('images/imgprofile.png')),
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                DateTime now = DateTime.now();
                List<bool> checkTime = [];

                String currentDate =
                    "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";
                String amPm = now.hour >= 12 ? 'PM' : 'AM';

                int hourIn12HourFormat =
                    now.hour > 12 ? now.hour - 12 : now.hour;

                String formattedTime =
                    '${_twoDigits(hourIn12HourFormat)}:${_twoDigits(now.minute)} $amPm';
                DateTime dateTime = _convertStringToDateTime(formattedTime);
                if (UserType == true) {
                  for (int i = 0;
                      i < appointment[index]["appointments"].length;
                      i++) {
                    if (currentDate ==
                        appointment[index]["appointments"][i]
                            ["appointmentDayDate"]) {
                      DateTime appointmentStartTime = _convertStringToDateTime(
                          appointment[index]["appointments"][i]
                              ["appointmentStart_time"]);

                      bool isCurrentBeforeStartTime =
                          _compareTimes(dateTime, appointmentStartTime);

                      DateTime appointmentEndTime = _convertStringToDateTime(
                          appointment[index]["appointments"][i]
                              ["appointmentEnd_time"]);
                      bool isCurrentBeforeEndTime =
                          _compareTimes(dateTime, appointmentEndTime);

                      if (isCurrentBeforeStartTime == false &&
                          isCurrentBeforeEndTime == true) {
                        checkTime.add(true);
                      } else {
                        checkTime.add(false);
                      }
                    } else {
                      checkTime.add(false);
                    }
                  }

                  if (checkTime.contains(true)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat_screen(
                            reciver_id: appointment[index]["appointments"][0]
                                ["id"]),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                        'الموعد غير متاح حالياً',
                        textAlign: TextAlign.center,
                      )),
                    );
                  }
                } else {
                  for (int i = 0;
                      i < appointment[index]["appointmentReservation"].length;
                      i++) {
                    if (currentDate ==
                        appointment[index]["appointmentReservation"][i]
                            ["appointmentDayDate"]) {
                      DateTime appointmentStartTime = _convertStringToDateTime(
                          appointment[index]["appointmentReservation"][i]
                              ["appointmentStart_time"]);

                      bool isCurrentBeforeStartTime =
                          _compareTimes(dateTime, appointmentStartTime);

                      DateTime appointmentEndTime = _convertStringToDateTime(
                          appointment[index]["appointmentReservation"][i]
                              ["appointmentEnd_time"]);
                      bool isCurrentBeforeEndTime =
                          _compareTimes(dateTime, appointmentEndTime);
                      if (isCurrentBeforeStartTime == false &&
                          isCurrentBeforeEndTime == true) {
                        checkTime.add(true);
                      } else {
                        checkTime.add(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                            'الموعد غير متاح حاليا',
                            textAlign: TextAlign.center,
                          )),
                        );
                      }
                    } else {
                      checkTime.add(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'الموعد غير متاح حاليا',
                          textAlign: TextAlign.center,
                        )),
                      );
                    }
                  }

                  if (checkTime.contains(true)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat_screen(
                            reciver_id: appointment[index]["Reservationuser"]
                                ["user"]["user_id"]),
                      ),
                    );
                  }
                }
              },
            ),
          ));
        },
      ),
    );
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  DateTime _convertStringToDateTime(String timeString) {
    List<String> parts = timeString.split(" ");
    String time = parts[0];
    String period = parts[1];

    List<String> timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (period.toUpperCase() == "PM" && hour != 12) {
      hour += 12;
    } else if (period.toUpperCase() == "AM" && hour == 12) {
      hour = 0;
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  bool _compareTimes(DateTime time1, DateTime time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour == time2.hour) {
      return time1.minute < time2.minute;
    }
    return false;
  }
}

class CustomAppBarShape extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(10.0)));
  }
}
