import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:project/Services/services.dart';

class BarcodeGuest extends StatefulWidget {
  const BarcodeGuest({Key? key}) : super(key: key);

  @override
  State<BarcodeGuest> createState() => _BarcodeGuestState();
}

class _BarcodeGuestState extends State<BarcodeGuest> {
  String variable1 = 'لا تتوفر معلومات'; // معلومات القيم الغذائية للمنتج
  String variable2 = ''; // لتخزين الباركود
  bool health = false; // قيمة لنحدد اذا المنتج مناسب ولا لا
  List<String> favorite = []; // List to store favorite barcode values
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  bool _showCameraPreview =
      false; // Flag to manage the visibility of the camera preview
  bool isProductScanned = false; // Flag to track if a barcode has been scanned
  Map<String, dynamic>? ProductInfo;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeCameraControllerFuture =
        _cameraController.initialize().then((_) {
      setState(() {
        _showCameraPreview =
            true; // Show the camera preview once it's initialized
      });
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
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        //-------------------------------------
                        SizedBox(width: 160),
                        Text(
                          'مسح الباركود',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------------------------------------
                //Images
                SizedBox(height: 0),
                SizedBox(height: 20),
                _showCameraPreview
                    ? Text(
                        'ثبت الكاميرا على الباركود',
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      )
                    : Text(""),
                SizedBox(height: 10),
                Container(
                  child: _showCameraPreview
                      ? Column(children: [
                          Container(
                              height: _showCameraPreview
                                  ? 350
                                  : 1, // Set your desired height here
                              width: _showCameraPreview
                                  ? 300
                                  : 1, // Set your desired width here
                              child: AspectRatio(
                                aspectRatio:
                                    _cameraController.value.aspectRatio,
                                child: CameraPreview(_cameraController),
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 100),
                                ElevatedButton(
                                  onPressed: _scanBarcode,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'امسح الباركود',
                                    style: GoogleFonts.robotoCondensed(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ])
                        ])
                      : Container(),
                ),
                SizedBox(height: 0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: 280,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'باركود المنتج  : $variable2', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'السعرات الحرارية : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["calories_value"] == -1 ? variable1 : ProductInfo!["calories_value"].toString() + ' كيلو كالوري ') : variable1 : variable1}', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'السكريات : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["sugar_value"] == -1 ? variable1 : ProductInfo!["sugar_value"].toString() + ' غرام ') : variable1 : variable1}', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'الدهون : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["fats_value"] == -1 ? variable1 : ProductInfo!["fats_value"].toString()) : variable1 : variable1}' +
                                  ' غرام ', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'البروتين : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["protein_value"] == -1 ? variable1 : ProductInfo!["protein_value"].toString() + ' غرام ') : variable1 : variable1}', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'الصوديوم : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["sodium_value"] == -1 ? variable1 : ProductInfo!["sodium_value"].toString() + ' ملغم ') : variable1 : variable1}', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              'الكربوهيدرات : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["carbohydrate_value"] == -1 ? variable1 : ProductInfo!["carbohydrate_value"].toString() + ' غرام ') : variable1 : variable1}', // Concatenate the variable value with the Arabic text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: !_showCameraPreview ? 20 : 0),
                    Visibility(
                        visible: !_showCameraPreview,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showCameraPreview = true;
                              _initializeCamera();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'فتح الكاميرا ',
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                // Conditionally show the message based on whether a barcode has been scanned
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scanBarcode() async {
    try {
      final barcodeValue = await FlutterBarcodeScanner.scanBarcode(
          '#FF0000', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeValue != '-1') {
        setState(() {
          _showCameraPreview =
              false; // Hide the camera preview before showing the barcode result
          variable2 = barcodeValue;
          isProductScanned =
              true; // Set the flag to true after scanning the barcode
        });
        RestAPIConector.GetProductInfoAPI(int.parse(variable2))
            .then((response) {
          setState(() {
            ProductInfo = response;
          });
        });
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }
}
