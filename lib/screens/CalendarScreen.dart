import 'package:flutter/cupertino.dart';
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
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenPage();
}

class _CalendarScreenPage extends State<CalendarScreen> {
  bool UserType = true;
  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
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
  }

  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return (Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          child: TableCalendar(
              locale: "en_US",
              rowHeight: 40,
              headerStyle:
                  HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected),
        ),
      ),
    ));
  }
}
