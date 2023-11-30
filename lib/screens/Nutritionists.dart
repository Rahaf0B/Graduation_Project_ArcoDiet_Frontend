import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project/screens/Home.dart';
import 'package:project/screens/NutritionistInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/services.dart';
import '../models/User.dart';

class Specialist {
  final String name;
  final String imageUrl;
  bool isFavorite;
  final double rating;
  final double price;
  final int user_id;

  Specialist({
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,
    required this.rating,
    required this.price,
    required this.user_id,
  });
}

class Nutritionists extends StatefulWidget {
  @override
  _NutritionistsState createState() => _NutritionistsState();
}

class _NutritionistsState extends State<Nutritionists> {
  List<Specialist>? _allNutritionist;
  List<Specialist>? _allFavNutritionist;

  Box? _userBox;
  User user = User.empty();

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

    setState(() {
      user = _userBox?.get('UserBox');
    });
    getAllFavNutritionist();

    return;
  }

  void getAllNutritionist() {
    RestAPIConector.getAllNutritionist().then((responseBody) {
      if (responseBody != {}) {
        bool fav = false;
        setState(() {
          _allNutritionist = responseBody.map((dynamic specialist) {
            if (!(_allFavNutritionist!.isEmpty) ||
                !(_allFavNutritionist == null)) {
              if (_allFavNutritionist!.any((specialistfav) =>
                  specialistfav.user_id == specialist['user']['user_id'])) {
                fav = true;
              } else {
                fav = false;
              }
            }
            return Specialist(
              name: specialist['user']['username'],
              imageUrl: specialist['user']['profile_pic'] == null
                  ? ""
                  : specialist['user']['profile_pic'],
              isFavorite: fav,
              rating: (specialist['rating'] as num?)?.toDouble() ?? -1.0,
              price: (specialist['Price'] as num?)?.toDouble() ?? -1.0,
              user_id: specialist['user']['user_id'],
            );
          }).toList();
        });
      }
    });
  }

  void getAllFavNutritionist() {
    RestAPIConector.getFavoriteNutritionist(user.token).then((responseBody) {
      if (responseBody != {}) {
        setState(() {
          _allFavNutritionist = responseBody.map((dynamic specialist) {
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

      getAllNutritionist();
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
                    leading: Icon(Icons.attach_money),
                    title: Text('ترتيب حسب السعر'),
                    onTap: () {
                      setState(() {
                        _sortByPriceAscending = !_sortByPriceAscending;
                        _allNutritionist?.sort((a, b) => _sortByPriceAscending
                            ? a.price.compareTo(b.price)
                            : b.price.compareTo(a.price));
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text('ترتيب حسب التقييم'),
                    onTap: () {
                      setState(() {
                        _sortByRatingAscending = !_sortByRatingAscending;
                        _allNutritionist?.sort((a, b) => _sortByRatingAscending
                            ? a.rating.compareTo(b.rating)
                            : b.rating.compareTo(a.rating));
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Text('الأخصائيون'),
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
                      labelText: 'ابحث عن أخصائي/ة تغذية',
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
              itemCount: _allNutritionist?.length,
              itemBuilder: (context, index) {
                final specialist = _allNutritionist?[index];
                if (_searchText.isNotEmpty &&
                    !specialist!.name.contains(_searchText)) {
                  return SizedBox.shrink();
                }
                return Card(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: specialist == null
                            ? null
                            : (specialist.imageUrl == ""
                                ? Image.asset(
                                    'images/nutritionistsapple.png',
                                    color: Colors.white,
                                  ).image
                                : NetworkImage((RestAPIConector.URLIP +
                                    specialist!.imageUrl))),
                      ),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(specialist == null ? "" : specialist!.name),
                              SizedBox(height: 8.0),
                              Column(
                                children: [
                                  Text(
                                    'التقييم: ${specialist == null ? "" : specialist!.rating == -1.0 ? "لم يتم التقييم" : specialist.rating.toString()}',
                                  ),
                                  Text(
                                    'السعر: ${specialist == null ? "" : specialist.price == -1.0 ? "غير محدد" : specialist.price.toString()}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              (specialist == null
                                      ? false
                                      : specialist.isFavorite)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: (specialist == null
                                      ? false
                                      : specialist.isFavorite)
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () {
                              setState(() {
                                specialist?.isFavorite = !specialist.isFavorite;
                                if (specialist?.isFavorite == false) {
                                  RestAPIConector.deleteFavoriteNutritionist(
                                      user.token, specialist!.user_id);
                                } else {
                                  RestAPIConector.addFavoriteNutritionist(
                                      user.token, specialist!.user_id);
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
                                    builder: (context) => Nutritionist_Info(
                                        user_id: specialist == null
                                            ? 0
                                            : specialist.user_id),
                                  ));
                            },
                            child: Text('حجز موعد'),
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
