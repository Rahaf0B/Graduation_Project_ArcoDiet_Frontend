import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/services.dart';
import '../models/User.dart';
import 'SuccessPayment.dart';
import 'controller.dart';

class Payment extends StatefulWidget {
  final today;
  final selectedIndex;
  final appointmentsTime;

  final user_id;
  final price;
  const Payment(
      {Key? key,
      required this.today,
      required this.selectedIndex,
      required this.appointmentsTime,
      required this.user_id,
      required this.price})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Box? _userBox;
  User user = User.empty();

  bool UserType = true;

  @override
  void initState() {
    _openBox();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _userBox = Hive.box('UserBox');

    setState(() {
      user = _userBox?.get('UserBox');
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                    ],
                  ),

                  //Email textField
                  Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    child: SvgPicture.asset('images/payment.svg',
                        height: 330, width: 330),
                  ),
                  SizedBox(height: 20),
                  Text(
                    ' المبلغ المطلوب للدفع:  ' +
                        (widget.price.toString() == -1
                            ? "0"
                            : widget.price.toString()) +
                        " شيكل ",
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.deepPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'رقم البطاقة',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 70.0),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 180,
                              height: 45,
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
                                          '    ! أدخل رقم البطاقة ';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //------------------------------------------------------
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'كود المرور',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 100.0),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 120,
                              height: 45,
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
                                          '    ! أدخل كود المرور ';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //----------------------------------------------------------------
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'تاريخ الإنتهاء',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 100.0),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 120,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: TextFormField(
                                  textDirection: TextDirection
                                      .rtl, // set text direction to right-to-left

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '  '
                                          '    ! أدخل تاريخ الإنتهاء ';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Colors.deepPurple.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //----------------------------------------------------------
                  SizedBox(height: 10),
                  //Password textField

                  SizedBox(height: 5),
                  //-------------------------------------
                  Container(
                    width: 300,
                    child: Divider(
                      color: Colors.deepPurple,
                      thickness: 1,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //----------------------------------------------------------

                      SizedBox(height: 70),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            RestAPIConector.ReservationAppointments(
                                    context,
                                    widget.today,
                                    widget.selectedIndex,
                                    widget.appointmentsTime,
                                    widget.user_id,
                                    user.token)
                                .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuccessPayment(),
                                ),
                              );
                            });
                            //
                          }
                        },
                        child: Text(
                          '            إتمام عملية الدفع            ',
                          style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      //----------------------------------------------------------
                    ],
                  ),
                  //-------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
