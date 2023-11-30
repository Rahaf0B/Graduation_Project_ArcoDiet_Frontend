import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/Viewproducts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'Home.dart';

class Product {
  final int product_id;
  final int barcode_number;
  final String product_name_english;
  final String product_name_arabic;
  final double product_weight;
  final double sugar_value;
  final double sodium_value;
  final double calories_value;
  final double fats_value;
  final double protein_value;
  final double cholesterol_value;
  final double carbohydrate_value;
  final int milk_existing;
  final int egg_existing;
  final int fish_existing;
  final int sea_components_existing;
  final int nuts_existing;
  final int peanut_existing;
  final int pistachio_existing;
  final int wheat_derivatives_existing;
  final int soybeans_existing;

  bool isFavorite;

  Product({
    required this.product_id,
    required this.barcode_number,
    required this.product_name_english,
    required this.product_name_arabic,
    required this.product_weight,
    required this.sugar_value,
    required this.sodium_value,
    required this.calories_value,
    required this.fats_value,
    required this.protein_value,
    required this.cholesterol_value,
    required this.carbohydrate_value,
    required this.milk_existing,
    required this.egg_existing,
    required this.fish_existing,
    required this.sea_components_existing,
    required this.nuts_existing,
    required this.peanut_existing,
    required this.pistachio_existing,
    required this.wheat_derivatives_existing,
    required this.soybeans_existing,
    this.isFavorite = false,
  });
}

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product>? _allProducts;
  List<Product>? _allfavProducts;

  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

  bool UserType = true;

  @override
  void initState() {
    super.initState();
    _openBox();

    super.initState();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;
    _userBox = Hive.box('UserBox');
    _nutritionistBox = Hive.box('NutritionistBox');
    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
      }
    });
    getallFavProducts();
    getllProducts();
    return;
  }

  void getllProducts() {
    RestAPIConector.getAllProduct().then((responseBody) {
      if (responseBody != {}) {
        setState(() {
          bool fav = false;
          _allProducts = responseBody.map((dynamic product) {
            if (_allfavProducts != null) {
              if (_allfavProducts!.any((productfav) =>
                  productfav.barcode_number == product["barcode_number"] &&
                  productfav.product_id == product["product_id"])) {
                fav = true;
              } else {
                fav = false;
              }
            } else {
              fav = false;
            }
            return Product(
                product_id: product["product_id"],
                barcode_number: product["barcode_number"],
                product_name_english: product["product_name_english"],
                product_name_arabic: product["product_name_arabic"],
                product_weight: product["product_weight"] == null
                    ? -1
                    : product["product_weight"],
                sugar_value: product["sugar_value"] == null
                    ? -1
                    : product["sugar_value"],
                sodium_value: product["sodium_value"] == null
                    ? -1
                    : product["sodium_value"],
                calories_value: product["calories_value"] == null
                    ? -1
                    : product["calories_value"],
                fats_value:
                    product["fats_value"] == null ? -1 : product["fats_value"],
                protein_value: product["protein_value"] == null
                    ? -1
                    : product["protein_value"],
                cholesterol_value: product["cholesterol_value"] == null
                    ? -1
                    : product["cholesterol_value"],
                carbohydrate_value: product["carbohydrate_value"] == null
                    ? -1
                    : product["carbohydrate_value"],
                milk_existing: product["milk_existing"] == null
                    ? -1
                    : product["milk_existing"],
                egg_existing: product["egg_existing"] == null
                    ? -1
                    : product["egg_existing"],
                fish_existing: product["fish_existing"] == null
                    ? -1
                    : product["fish_existing"],
                sea_components_existing:
                    product["sea_components_existing"] == null
                        ? -1
                        : product["sea_components_existing"],
                nuts_existing: product["nuts_existing"] == null
                    ? -1
                    : product["nuts_existing"],
                peanut_existing: product["peanut_existing"] == null
                    ? -1
                    : product["peanut_existing"],
                pistachio_existing: product["pistachio_existing"] == null
                    ? -1
                    : product["pistachio_existing"],
                wheat_derivatives_existing:
                    product["wheat_derivatives_existing"] == null
                        ? -1
                        : product["wheat_derivatives_existing"],
                soybeans_existing: product["soybeans_existing"] == null
                    ? -1
                    : product["soybeans_existing"],
                isFavorite: fav);
          }).toList();
        });
      }
    });
  }

  void getallFavProducts() {
    RestAPIConector.getFavoriteProduct(
            UserType == true ? user.token : nutritionist.token)
        .then((responseBody) {
      if (responseBody != {}) {
        setState(() {
          _allfavProducts = responseBody.map((dynamic product) {
            return Product(
                product_id: product["product_id"],
                barcode_number: product["barcode_number"],
                product_name_english: product["product_name_english"],
                product_name_arabic: product["product_name_arabic"],
                product_weight: product["product_weight"] == null
                    ? -1
                    : product["product_weight"],
                sugar_value: product["sugar_value"] == null
                    ? -1
                    : product["sugar_value"],
                sodium_value: product["sodium_value"] == null
                    ? -1
                    : product["sodium_value"],
                calories_value: product["calories_value"] == null
                    ? -1
                    : product["calories_value"],
                fats_value:
                    product["fats_value"] == null ? -1 : product["fats_value"],
                protein_value: product["protein_value"] == null
                    ? -1
                    : product["protein_value"],
                cholesterol_value: product["cholesterol_value"] == null
                    ? -1
                    : product["cholesterol_value"],
                carbohydrate_value: product["carbohydrate_value"] == null
                    ? -1
                    : product["carbohydrate_value"],
                milk_existing: product["milk_existing"] == null
                    ? -1
                    : product["milk_existing"],
                egg_existing: product["egg_existing"] == null
                    ? -1
                    : product["egg_existing"],
                fish_existing: product["fish_existing"] == null
                    ? -1
                    : product["fish_existing"],
                sea_components_existing:
                    product["sea_components_existing"] == null
                        ? -1
                        : product["sea_components_existing"],
                nuts_existing: product["nuts_existing"] == null
                    ? -1
                    : product["nuts_existing"],
                peanut_existing: product["peanut_existing"] == null
                    ? -1
                    : product["peanut_existing"],
                pistachio_existing: product["pistachio_existing"] == null
                    ? -1
                    : product["pistachio_existing"],
                wheat_derivatives_existing:
                    product["wheat_derivatives_existing"] == null
                        ? -1
                        : product["wheat_derivatives_existing"],
                soybeans_existing: product["soybeans_existing"] == null
                    ? -1
                    : product["soybeans_existing"]);
          }).toList();
        });
      }
    });
  }

  bool _sortByPriceAscending = true;
  bool _sortByRatingAscending = true;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    title: Text('ترتيب حسب قيمة السعرات الحرارية'),
                    onTap: () {
                      setState(() {
                        _sortByPriceAscending = !_sortByPriceAscending;
                        _allProducts?.sort((a, b) => _sortByPriceAscending
                            ? a.calories_value.compareTo(b.calories_value)
                            : b.calories_value.compareTo(a.calories_value));
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    title: Text('ترتيب حسب قيمة السكر'),
                    onTap: () {
                      setState(() {
                        _sortByRatingAscending = !_sortByRatingAscending;
                        _allProducts?.sort((a, b) => _sortByRatingAscending
                            ? a.sugar_value.compareTo(b.sugar_value)
                            : b.sugar_value.compareTo(a.sugar_value));
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    title: Text('ترتيب حسب قيمة الدهون'),
                    onTap: () {
                      setState(() {
                        _sortByRatingAscending = !_sortByRatingAscending;
                        _allProducts?.sort((a, b) => _sortByRatingAscending
                            ? a.fats_value.compareTo(b.fats_value)
                            : b.fats_value.compareTo(a.fats_value));
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Text('المنتجات'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'ابحث عن المنتج',
                      alignLabelWithHint: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                Icon(Icons.search),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allProducts?.length,
              itemBuilder: (context, index) {
                final product = _allProducts?[index];

                if (_searchText.isNotEmpty &&
                    !product!.product_name_arabic.contains(_searchText)) {
                  return SizedBox.shrink();
                }
                return Card(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 7.0),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product == null
                                    ? ""
                                    : product.product_name_arabic,
                                style: TextStyle(fontSize: 13.3),
                              ),
                              SizedBox(height: 5.0),
                            ],
                          ),
                          SizedBox(width: 2),
                          IconButton(
                            icon: Icon(
                              (product == null ? false : product.isFavorite)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  (product == null ? false : product.isFavorite)
                                      ? Colors.red
                                      : null,
                            ),
                            onPressed: () {
                              setState(() {
                                product?.isFavorite = !product.isFavorite;
                                if (product?.isFavorite == false) {
                                  RestAPIConector.deleteFavoriteProduct(
                                      UserType == true
                                          ? user.token
                                          : nutritionist.token,
                                      product!.product_id);
                                } else {
                                  RestAPIConector.addFavoriteProduct(
                                      UserType == true
                                          ? user.token
                                          : nutritionist.token,
                                      product!.product_id);
                                }
                              });
                            },
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewProducts(
                                      product_id: product!.product_id),
                                ),
                              );
                            },
                            child: Text(
                              'الاطلاع على المنتج',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
