import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/Products.dart';
import 'package:project/screens/barcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/Nutritionist.dart';
import '../models/User.dart';
import 'NutritionistInfo.dart';
import 'Nutritionists.dart';
import 'SecPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenPage();
}

class _HomeScreenPage extends State<HomeScreen> {
  List<Specialist> _allNutritionist = [];

  bool UserType = true;
  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;

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

    return;
  }

  @override
  void initState() {
    _openBox();
    RestAPIConector.getHighestNutritionist().then((responseBody) {
      if (responseBody != {}) {
        setState(() {
          _allNutritionist = responseBody.map((dynamic specialist) {
            return Specialist(
              name: specialist['user']['username'],
              imageUrl: specialist['user']['profile_pic'] == null
                  ? ""
                  : specialist['user']['profile_pic'],
              isFavorite: false,
              rating: (specialist['rating'] as num?)?.toDouble() ?? -1.0,
              price: (specialist['Price'] as num?)?.toDouble() ?? -1.0,
              user_id: specialist['user']['user_id'],
            );
          }).toList();
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Barcode(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10.0), // set the border radius as desired
                            child: Image.asset(
                              'images/imagebarcodefeature.png',
                              width: 50, // set the desired width
                              height: 50, // set the desired height
                              fit: BoxFit
                                  .cover, // scale and crop the image to fit the dimensions
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('مسح الباركود'),
                  ],
                ),
              ),
              SizedBox(width: 15),
              //--------------------------------------------
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10.0), // set the border radius as desired
                            child: Image.asset(
                              'images/market.png',
                              width: 50, // set the desired width
                              height: 50, // set the desired height
                              fit: BoxFit
                                  .cover, // scale and crop the image to fit the dimensions
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('المنتجات'),
                  ],
                ),
              ),
              SizedBox(width: 15),

              //----------------------------------------------------------------
              UserType == true
                  ? Visibility(
                      visible: UserType,
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Nutritionists(),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // set the border radius as desired
                                    child: Image.asset(
                                      'images/nutri.png',
                                      width: 50, // set the desired width
                                      height: 50, // set the desired height
                                      fit: BoxFit
                                          .cover, // scale and crop the image to fit the dimensions
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text('الأخصائيون'),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _allNutritionist.length,
            itemBuilder: (context, index) {
              final specialist = _allNutritionist[index];

              return Card(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    leading: ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(20),
                        child: Image.network(
                          RestAPIConector.getImage(specialist.imageUrl),
                          errorBuilder: ((context, error, stackTrace) =>
                              Image.asset('images/imgprofile.png')),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(specialist.name),
                            Column(
                              children: [
                                Text(
                                  'التقييم: ${specialist.rating == -1.0 ? "لم يتم التقييم" : specialist.rating.toString()}',
                                ),
                                Text(
                                  'السعر: ${specialist.price == -1.0 ? "غير محدد" : specialist.price.toString()}',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        UserType
                            ? IconButton(
                                icon: Icon(
                                  specialist.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      specialist.isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    specialist.isFavorite =
                                        !specialist.isFavorite;

                                    if (specialist?.isFavorite == false) {
                                      RestAPIConector
                                          .deleteFavoriteNutritionist(
                                              user.token, specialist!.user_id);
                                    } else {
                                      RestAPIConector.addFavoriteNutritionist(
                                          user.token, specialist!.user_id);
                                    }
                                  });
                                },
                              )
                            : Container(),
                        Spacer(),
                        UserType
                            ? ElevatedButton(
                                onPressed: () {
                                  // Implement your logic to book an appointment
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Nutritionist_Info(
                                            user_id: specialist == null
                                                ? 0
                                                : specialist.user_id),
                                      ));
                                },
                                child: Text('حجز موعد'),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}
