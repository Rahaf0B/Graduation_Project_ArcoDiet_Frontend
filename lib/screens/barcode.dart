import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Nutritionist.dart';
import '../models/User.dart';

class Barcode extends StatefulWidget {
  const Barcode({Key? key}) : super(key: key);

  @override
  State<Barcode> createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
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

  // القيم الغذائية للمقارنة ولنطبعهم
  double sugarValue = 190; // value in gram
  double sodiumValue = 200; // value in mg
  double fat = 200; // value in mg
  double Calories = 200; // value in mg
  double ProtinValue = 200; // value in mg
  double CarbsValue = 200; // value in mg

  // diseases
  bool hasDiabetes = false;
  bool hasHypertensionOrKidneysOrLiverDisease = false;
  // Allergies
  bool userHasMilkAllergie = false;
  bool userHasEggAllergie = false;
  bool userHasfishAllergie = false;
  bool userHassea_ingredientsAllergie = false;
  bool userHasnutsAllergie = false;
  bool userHaspeanutAllergie = false;
  bool userHaspistachioAllergie = true;
  bool userHaswheat_derivativesAllergie = false;
  bool userHassoyAllergie = false;
  //allergies للبرودكت
  Map<String, int> allergies = {
    'milk': 0,
    'egg': 0,
    'fish': 0,
    'sea_ingredients': 0,
    'nuts': 0,
    'peanut': 0,
    'pistachio': 0,
    'wheat_derivatives': 0,
    'soy': 0,
  };
  void checkProductSuitability() {
    // Check if the user has any allergies
    // Check allergies using for loop
    bool isSuitableForUser = true;
    for (String allergen in allergies.keys) {
      bool userHasAllergy = false;
      switch (allergen) {
        case 'milk':
          userHasAllergy = userHasMilkAllergie;
          break;
        case 'egg':
          userHasAllergy = userHasEggAllergie;
          break;
        case 'fish':
          userHasAllergy = userHasfishAllergie;
          break;
        case 'sea_ingredients':
          userHasAllergy = userHassea_ingredientsAllergie;
          break;
        case 'nuts':
          userHasAllergy = userHasnutsAllergie;
          break;
        case 'peanut':
          userHasAllergy = userHaspeanutAllergie;
          break;
        case 'pistachio':
          userHasAllergy = userHaspistachioAllergie;
          break;
        case 'wheat_derivatives':
          userHasAllergy = userHaswheat_derivativesAllergie;
          break;
        case 'soy':
          userHasAllergy = userHassoyAllergie;
          break;
      }

      if (userHasAllergy && allergies[allergen] == 1) {
        isSuitableForUser = false;
        break;
      }
    }

    // Check nutritional values
    if (hasDiabetes && sugarValue > 5) {
      isSuitableForUser =
          false; // The product is not suitable for the user with diabetes
    }

    if (hasHypertensionOrKidneysOrLiverDisease && sodiumValue > 140) {
      isSuitableForUser =
          false; // The product is not suitable for the user with hypertension, kidneys, or liver disease
    }

    // Print the result based on product suitability
    setState(() {
      health = isSuitableForUser;
    });
  }

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;
  bool UserType = true;

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;

    _userBox = await Hive.box('UserBox');
    _nutritionistBox = await Hive.box('NutritionistBox');
    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
        if (user.allergies.isNotEmpty && user.allergies != null) {
          for (int i = 0; i < user.allergies.length; i++) {
            if (user.allergies[i] == "حليب") {
              userHasMilkAllergie = true;
            }
            if (user.allergies[i] == "بيض") {
              userHasEggAllergie = true;
            }
            if (user.allergies[i] == "سمك") {
              userHasfishAllergie = true;
            }
            if (user.allergies[i] == "مكونات بحرية") {
              userHassea_ingredientsAllergie = true;
            }
            if (user.allergies[i] == "مكسرات") {
              userHasnutsAllergie = true;
            }
            if (user.allergies[i] == "فول سوداني") {
              userHaspeanutAllergie = true;
            }
            if (user.allergies[i] == "فستق") {
              userHaspistachioAllergie = true;
            }
            if (user.allergies[i] == "مشتقات القمح") {
              userHaswheat_derivativesAllergie = true;
            }
            if (user.allergies[i] == "الصويا") {
              userHassoyAllergie = true;
            }
          }
        }
        if (user.diseases.isNotEmpty && user.diseases != null) {
          for (int j = 0; j < user.diseases.length; j++) {
            if (user.diseases[j] == "السكري") {
              hasDiabetes = true;
            }
            if (user.diseases[j] == "الضغط") {
              hasHypertensionOrKidneysOrLiverDisease = true;
            }
            if (user.diseases[j] == "الكلى") {
              hasHypertensionOrKidneysOrLiverDisease = true;
            }
            if (user.diseases[j] == "الكبد") {
              hasHypertensionOrKidneysOrLiverDisease = true;
            }
          }
        }
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
        if (nutritionist.allergies.isNotEmpty &&
            nutritionist.allergies != null) {
          for (int i = 0; i < nutritionist.allergies.length; i++) {
            if (nutritionist.allergies[i] == "حليب") {
              userHasMilkAllergie = true;
            }
            if (nutritionist.allergies[i] == "بيض") {
              userHasEggAllergie = true;
            }
            if (nutritionist.allergies[i] == "سمك") {
              userHasfishAllergie = true;
            }
            if (nutritionist.allergies[i] == "مكونات بحرية") {
              userHassea_ingredientsAllergie = true;
            }
            if (nutritionist.allergies[i] == "مكسرات") {
              userHasnutsAllergie = true;
            }
            if (nutritionist.allergies[i] == "فول سوداني") {
              userHaspeanutAllergie = true;
            }
            if (nutritionist.allergies[i] == "فستق") {
              userHaspistachioAllergie = true;
            }
            if (nutritionist.allergies[i] == "مشتقات القمح") {
              userHaswheat_derivativesAllergie = true;
            }
            if (nutritionist.allergies[i] == "الصويا") {
              userHassoyAllergie = true;
            }
          }
        }
        if (nutritionist.diseases.isNotEmpty && nutritionist.diseases != null) {
          for (int j = 0; j < nutritionist.diseases.length; j++) {
            if (nutritionist.diseases[j] == "السكري") {
              hasDiabetes = true;
            }
            if (nutritionist.diseases[j] == "الضغط") {
              hasHypertensionOrKidneysOrLiverDisease = true;
            }
            if (nutritionist.diseases[j] == "الكلى") {
              hasHypertensionOrKidneysOrLiverDisease = true;
            }
            if (nutritionist.diseases[j] == "الكبد") {
              hasHypertensionOrKidneysOrLiverDisease = true;
            }
          }
        }
      }
    });

    _initializeCamera();
    return;
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ),
                            );
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
                // Conditionally show the camera preview based on the flag
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
                              'الدهون : ${ProductInfo != null ? ProductInfo!.isNotEmpty ? (ProductInfo!["fats_value"] == -1 ? variable1 : ProductInfo!["fats_value"].toString() + ' غرام ') : variable1 : variable1}', // Concatenate the variable value with the Arabic text
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
                Visibility(
                    visible: isProductScanned,
                    child: Text(
                      health
                          ? 'هذا المنتج مناسب لحالتك الصحية'
                          : 'هذا المنتج ليس مناسب لحالتك الصحية',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: AddBarcodetoFav,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'أضف للمفضلة',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
          isProductScanned = true;
          // Set the flag to true after scanning the barcode
        });
        RestAPIConector.GetProductInfoAPI(int.parse(variable2))
            .then((response) {
          setState(() {
            ProductInfo = response;

            allergies = {
              'milk': response["milk_existing"],
              'egg': response["egg_existing"],
              'fish': response["fish_existing"],
              'sea_ingredients': response["sea_components_existing"],
              'nuts': response["nuts_existing"],
              'peanut': response["peanut_existing"],
              'pistachio': response["pistachio_existing"],
              'wheat_derivatives': response["wheat_derivatives_existing"],
              'soy': response["soybeans_existing"],
            };
            sugarValue = response["sugar_value"];
            sodiumValue = response["sodium_value"];
            fat = response["fats_value"];
            Calories = response["calories_value"];
            ProtinValue = response["protein_value"];
            CarbsValue = response["carbohydrate_value"];
          });
          checkProductSuitability();
        });
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  void AddBarcodetoFav() {
    setState(() {
      if (variable2.isNotEmpty) {
        RestAPIConector.addFavoriteProduct(
            UserType == true ? user.token : nutritionist.token,
            ProductInfo != null
                ? (ProductInfo!.isNotEmpty ? ProductInfo!["product_id"] : 0)
                : 0);
      }
    });
  }
}
