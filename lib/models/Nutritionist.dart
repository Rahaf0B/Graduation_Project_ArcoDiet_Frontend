import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'Nutritionist.g.dart'; // This line is required for code generation


@HiveType(typeId: 1)
class Nutritionist  extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String email;

  @HiveField(4)
  String gender;

  @HiveField(5)
  List<String> allergies;

  @HiveField(6)
  List<String> diseases;

  @HiveField(7)
  String profile_pic;

  @HiveField(8)
  int age;

  @HiveField(9)
  String date_of_birth;
  @HiveField(10)
  double weight;

  @HiveField(11)
  double height;

  @HiveField(12)
  String token;

  @HiveField(13)
  String UserType;

  @HiveField(14)
   int phone_number;

  @HiveField(15)
  int rating;

  @HiveField(16)
  String description;

  @HiveField(17)
  int experience_years;

  @HiveField(18)
  String collage;

  @HiveField(19)
  String Specialization;
  
  @HiveField(20)
  int Price;

  Nutritionist ({required this.id,required this.firstName,required this.lastName,required this.email,required this.gender,required this.profile_pic, required this.diseases,required this.allergies, required this.age,required this.date_of_birth, required this.weight, required this.height, required this.token, required this.UserType, required this.phone_number, required this.rating, required this.description, required this.experience_years, required this.collage, required this.Specialization, required this.Price});


  Nutritionist.empty() : id = -1,
    firstName="",
    lastName="",
    email="",
    gender="",
    profile_pic="",
diseases=[],
allergies=[],
    age = 0,
    date_of_birth="",
    weight=0,
    height=0,
    token="",
    UserType="",
    phone_number=-1,
    rating=-1,
    description="",
    experience_years=-1,
    collage="",
    Specialization="",
    Price=-1;
  
}