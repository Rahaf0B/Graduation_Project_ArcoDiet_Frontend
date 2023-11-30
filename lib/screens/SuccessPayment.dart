import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SecPage.dart';
import 'SignUp1.dart';

import 'controller.dart';
import 'home.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({Key? key}) : super(key: key);
  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

final GlobalKey<FormState> SuccessPaymentFormKey = GlobalKey<FormState>();

class _SuccessPaymentState extends State<SuccessPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: SuccessPaymentFormKey,
            child: Center(
              child: Column(
                children: [
                  //Images
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    child: SvgPicture.asset('images/Successfulpay.svg',
                        height: 350, width: 350),
                  ),
                  //--------------------------------------------
                  Text(
                    '! تم الدفع بنجاح',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  //--------------------------------------------
                  Text(
                    'سنرسل تفاصيل الطلب والفاتورة في رقم الاتصال',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.deepPurple,
                      fontSize: 16,
                    ),
                  ),
                  //--------------------------------------------------------
                  Text(
                    'الخاص بك والبريد الإلكتروني المسجل',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.deepPurple,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 40),
                  //--------------------------------------------
                  //signin button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    },
                    child: Text(
                      '            الرجوع للصفحة الرئيسية            ',
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  //--------------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
