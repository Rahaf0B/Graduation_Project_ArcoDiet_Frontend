import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project/Services/services.dart';
import 'package:project/screens/ForgetPass3.dart';
import 'dart:convert';
import 'controller.dart';

class ForgetPass2 extends StatefulWidget {
  final String? Email;
  const ForgetPass2({Key? key, @required this.Email}) : super(key: key);

  @override
  State<ForgetPass2> createState() => _ForgetPass2State();
}

class _ForgetPass2State extends State<ForgetPass2> {
  List<dynamic> bookList = [];
  String? Code;
  final GlobalKey<FormState> ForgetPass2FormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: ForgetPass2FormKey,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Image(image: AssetImage('images/arro.png')),
                        ),
                      ],
                    ),
                  ),

                  //--------------------------------------------

                  //Image
                  Image(
                    image: AssetImage('images/forgetpass2.png'),
                    width: 250,
                    height: 230,
                  ),

                  //----------------------------------------------------------------
                  //----------------------------------------------------------------
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.only(right: 50.0),
                      child: Text(
                        'ادخال رمز التحقق',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // للمباعدة بين العناصر
                  SizedBox(height: 10),

                  //Email textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          textDirection: TextDirection
                              .rtl, // set text direction to right-to-left
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '  '
                                  '                                                ! أدخل رمز التحقق ';
                            } else {
                              Code = value as String;
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: Image.asset('images/Vector.png'),
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
                                  width: 2,
                                  color: Colors.deepPurple.withOpacity(1.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 40),
                  //----------------------------------------------------------------
                  //button
                  TextButton(
                      onPressed: () {
                        RestAPIConector.reSendCode(widget.Email!, context);
                      },
                      child: Text(
                        '  ارسال الرمز مرة اخرى  ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ))),

                  //----------------------------------------------------------------
                  // للمباعدة بين العناصر
                  SizedBox(height: 20),
                  //----------------------------------------------------------------
                  //button
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (ForgetPass2FormKey.currentState!.validate()) {
                            _checkCode(Code!, widget.Email!, context);
                          }
                        });
                      },
                      child: Text(
                        '  استمرار  ',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ))),
                  //----------------------------------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkCode(String Code, String Email, BuildContext context) async {
    final url = 'http://192.168.1.8:8000/api/auth/checkVerfCode';

    final body =
        jsonEncode({"email": Email.toLowerCase(), "verificationCode": Code});
    final headers = {'Content-Type': 'application/json'};

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (json.decode(utf8.decode(response.bodyBytes))['message'] ==
        "Correct verification Code") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgetPass3(
            Email: Email,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'الكود غير صحيح',
          textAlign: TextAlign.center,
        )),
      );
    }
  }
}
