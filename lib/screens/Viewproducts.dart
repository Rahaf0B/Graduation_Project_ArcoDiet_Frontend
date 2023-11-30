import 'package:flutter/material.dart';
import 'package:project/Services/services.dart';
import 'package:project/screens/Products.dart';

import 'Home.dart';

class ViewProducts extends StatefulWidget {
  final product_id;
  const ViewProducts({Key? key, required this.product_id}) : super(key: key);

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  int sugarValue = 190; // value in gram
  int sodiumValue = 200; // value in mg
  int fat = 200; // value in mg
  int Calories = 200; // value in mg
  int ProtinValue = 200; // value in mg
  int CarbsValue = 200; // value in mg

  String variable1 = 'لا تتوفر معلومات'; // معلومات القيم الغذائية للمنتج
  String variable2 = ''; // لتخزين الباركود
  bool health = false; // قيمة لنحدد اذا المنتج مناسب ولا لا
  List<String> favorite = []; // List to store favorite barcode values

  late Future<void> _initializeCameraControllerFuture;
  bool _showCameraPreview =
      false; // Flag to manage the visibility of the camera preview
  bool isProductScanned = false; // Flag to track if a barcode has been scanned
  Map<String, dynamic>? ProductInfo;

  @override
  void initState() {
    getProductInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getProductInfo() {
    RestAPIConector.getProductById(widget.product_id).then((response) {
      setState(() {
        ProductInfo = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(left: 65),
          child: Text(
            'المعلومات الغذائية للمنتج',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Products(),
              ),
            );
          },
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // تحديد اتجاه اللغة العربية
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItem(
                  'السعرات الحرارية',
                  ProductInfo != null
                      ? ProductInfo!.isNotEmpty
                          ? (ProductInfo!["calories_value"] == -1
                              ? variable1
                              : ProductInfo!["calories_value"].toString() +
                                  ' كيلو كالوري ')
                          : variable1
                      : variable1,
                  ''),
              SizedBox(height: 8),
              _buildItem(
                  'السكريات',
                  ProductInfo != null
                      ? ProductInfo!.isNotEmpty
                          ? (ProductInfo!["sugar_value"] == -1
                              ? variable1
                              : ProductInfo!["sugar_value"].toString() +
                                  ' غرام ')
                          : variable1
                      : variable1,
                  ''),
              SizedBox(height: 8),
              _buildItem(
                  'الدهون',
                  ProductInfo != null
                      ? ProductInfo!.isNotEmpty
                          ? (ProductInfo!["fats_value"] == -1
                              ? variable1
                              : ProductInfo!["fats_value"].toString() +
                                  ' غرام ')
                          : variable1
                      : variable1,
                  ''),
              SizedBox(height: 8),
              _buildItem(
                  'البروتين',
                  ProductInfo != null
                      ? ProductInfo!.isNotEmpty
                          ? (ProductInfo!["protein_value"] == -1
                              ? variable1
                              : ProductInfo!["protein_value"].toString() +
                                  ' غرام ')
                          : variable1
                      : variable1,
                  ''),
              SizedBox(height: 8),
              _buildItem(
                  'الصوديوم',
                  ProductInfo != null
                      ? ProductInfo!.isNotEmpty
                          ? (ProductInfo!["sodium_value"] == -1
                              ? variable1
                              : ProductInfo!["sodium_value"].toString() +
                                  ' ملغم ')
                          : variable1
                      : variable1,
                  ''),
              SizedBox(height: 8),
              _buildItem(
                  'الكربوهيدرات',
                  ProductInfo != null
                      ? ProductInfo!.isNotEmpty
                          ? (ProductInfo!["carbohydrate_value"] == -1
                              ? variable1
                              : ProductInfo!["carbohydrate_value"].toString() +
                                  ' غرام ')
                          : variable1
                      : variable1,
                  ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value, String unit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.purple[50], // لون بنفسجي فاتح
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$value',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 6), // إضافة مسافة بين الرقم والوحدة
              Text(
                unit,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
