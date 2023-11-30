import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';
import 'package:project/models/Nutritionist.dart';
import 'package:project/models/User.dart';

import '../screens/ForgetPass2.dart';
import '../screens/home.dart';
import '../screens/login_screen.dart';

class RestAPIConector {
  static String URLIP = "http://172.19.1.150:8000";
  // static String URLIP = "http://172.19.1.150:8000";
  static late bool UserType;
  static bool LogedIn = false;

  static Future<void> FillUserData(String token, bool is_reqUser,
      bool is_Nutritionist, Box _userBox, Box _nutritionistBox) async {
    if (is_reqUser == true) {
      RestAPIConector.getUserDataAPI(token).then((responceBody) async {
        List<String> allergies = [];
        List<String> diseases = [];
        for (int i = 0; i < responceBody["user"]["allergies"].length; i++) {
          allergies.add(responceBody["user"]["allergies"][i]["allergies_name"]);
        }
        for (int i = 0; i < responceBody["user"]["diseases"].length; i++) {
          diseases.add(responceBody["user"]["diseases"][i]["diseases_name"]);
        }
        User user = User(
            id: responceBody["user"]["user_id"],
            firstName: responceBody["user"]["first_name"],
            lastName: responceBody["user"]["last_name"],
            email: responceBody["user"]["email"],
            age: responceBody["user"]["age"],
            date_of_birth: responceBody["user"]["date_of_birth"],
            gender: responceBody["user"]["gender"],
            profile_pic: responceBody["user"]["profile_pic"] == null
                ? ""
                : responceBody["user"]["profile_pic"],
            height: responceBody["user"]["height"],
            weight: responceBody["user"]["weight"],
            allergies: allergies,
            diseases: diseases,
            token: token,
            UserType: "reqUser");
        await _userBox?.put('UserBox', user);
      });
    } else if (is_Nutritionist == true) {
      RestAPIConector.getNutritionistDataAPI(token).then((responceBody) async {
        List<String> allergies = [];
        List<String> diseases = [];
        for (int i = 0; i < responceBody["user"]["allergies"].length; i++) {
          allergies.add(responceBody["user"]["allergies"][i]["allergies_name"]);
        }
        for (int i = 0; i < responceBody["user"]["diseases"].length; i++) {
          diseases.add(responceBody["user"]["diseases"][i]["diseases_name"]);
        }
        Nutritionist user = Nutritionist(
            id: responceBody["user"]["user_id"],
            firstName: responceBody["user"]["first_name"],
            lastName: responceBody["user"]["last_name"],
            email: responceBody["user"]["email"],
            age: responceBody["user"]["age"],
            date_of_birth: responceBody["user"]["date_of_birth"],
            gender: responceBody["user"]["gender"],
            profile_pic: responceBody["user"]["profile_pic"] == null
                ? ""
                : responceBody["user"]["profile_pic"],
            height: responceBody["user"]["height"],
            weight: responceBody["user"]["weight"],
            allergies: allergies,
            diseases: diseases,
            token: token,
            UserType: "nutritionist",
            phone_number: responceBody["phone_number"] == null
                ? -1
                : responceBody["phone_number"],
            rating:
                responceBody["rating"] == null ? -1 : responceBody["rating"],
            description: responceBody["description"] == null
                ? ""
                : responceBody["description"],
            experience_years: responceBody["experience_years"] == null
                ? -1
                : responceBody["experience_years"],
            collage:
                responceBody["collage"] == null ? "" : responceBody["collage"],
            Specialization: responceBody["Specialization"] == null
                ? ""
                : responceBody["Specialization"],
            Price: responceBody["Price"] == null ? -1 : responceBody["Price"]);
        await _userBox?.put('UserBox', user);
      });
    }
  }

  static Future<List<dynamic>> LoginUserApi(
      String Email, String password, BuildContext context) async {
    String url = URLIP + '/api/auth/login';
    List<dynamic> Userdata = [];
    final headers = {
      'Content-Type': 'application/json',
    };
    final body =
        jsonEncode({"email": Email.toLowerCase(), "password": password});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          ' تأكد من الايميل او كلمة المرور',
          textAlign: TextAlign.center,
        )),
      );
      return ["", false, false];
    } else {
      LogedIn = true;
      UserType = json.decode(utf8.decode(response.bodyBytes))['is_reqUser'];
      var token = json.decode(utf8.decode(response.bodyBytes))['token'];
      return [
        token,
        json.decode(utf8.decode(response.bodyBytes))['is_reqUser'],
        json.decode(utf8.decode(response.bodyBytes))['is_Nutritionist']
      ];
    }
  }

  static Future<Map<String, dynamic>> getUserDataAPI(String token) async {
    String url = URLIP + '/api/auth/user';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> getNutritionistDataAPI(
      String token) async {
    String url = URLIP + '/api/auth/nutritionist';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> RegisterUserAPI(
      String Fname,
      String Lname,
      String Email,
      String year,
      String month,
      String day,
      String gender,
      String password,
      BuildContext context) async {
    final url = URLIP + '/api/auth/registerReqUser';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "user": {
        "email": Email.toLowerCase(),
        "password": password,
        "first_name": Fname,
        "last_name": Lname,
        "gender": gender,
        "date_of_birth":
            year.toString() + "-" + month.toString() + "-" + day.toString()
      }
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'الايمل مستخدم الرجاء ادخال ايميل اّخر',
          textAlign: TextAlign.center,
        )),
      );
      return {};
    } else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  static Future<List<dynamic>> getAllergies() async {
    var url = Uri.parse(URLIP + '/api/auth/getallergies');
    http.Response response = await http.get(url);
    String val = response.body;
    List<dynamic> data = jsonDecode(val);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<List<dynamic>> getDiseases() async {
    var url2 = Uri.parse(URLIP + '/api/auth/getalldisease');
    http.Response response2 = await http.get(url2);
    String val2 = response2.body;

    return json.decode(utf8.decode(response2.bodyBytes));
  }

  static Future<Map<String, dynamic>> addUserInformationAPI(
      String? token,
      List<String> selectedItems,
      List<String> selectedItems2,
      double? userHight,
      double? userWight,
      List<String>? allergiesValue,
      List<String>? diseasesValue,
      int Userid) async {
    final allergiesIndex = [];
    final diseasesIndex = [];
    for (int i = 0; i < selectedItems.length; i++) {
      var index = allergiesValue?.indexOf(selectedItems[i]);
      if (index == 0) {
        break;
      } else {
        allergiesIndex.add(index);
      }
    }

    for (int i = 0; i < selectedItems2.length; i++) {
      var index = diseasesValue?.indexOf(selectedItems2[i]);
      if (index == 0) {
        break;
      } else {
        diseasesIndex.add(index);
      }
    }

    final url = URLIP + '/api/auth/info/$Userid/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "allergies": allergiesIndex,
      "diseases": diseasesIndex,
      "weight": userWight,
      "height": userHight,
    });

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> editHealthInformationAPI(
      String? token,
      List<String> selectedItems,
      List<String> selectedItems2,
      double? userHight,
      double? userWight,
      List<String>? allergiesValue,
      List<String>? diseasesValue,
      int Userid) async {
    final allergiesIndex = [];
    final diseasesIndex = [];
    for (int i = 0; i < selectedItems.length; i++) {
      var index = allergiesValue?.indexOf(selectedItems[i]);
      if (index == 0) {
        break;
      } else {
        allergiesIndex.add(index);
      }
    }

    for (int i = 0; i < selectedItems2.length; i++) {
      var index = diseasesValue?.indexOf(selectedItems2[i]);
      if (index == 0) {
        break;
      } else {
        diseasesIndex.add(index);
      }
    }

    final url = URLIP + '/api/auth/edithealth/$Userid/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "allergies": allergiesIndex,
      "diseases": diseasesIndex,
      "weight": userWight,
      "height": userHight,
    });

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<void> editProfilePic(
      PickedFile image, String? token, int Userid, User user) async {
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse(URLIP + '/api/auth/editpic/$Userid/'),
    );

    var filePath = image.path;
    if (filePath == null) {
      // Handle the case when filePath is null
      return;
    }
    var imageExtension = "";
    var stream = http.ByteStream(Stream.castFrom(File(image.path).openRead()));
    var length = File(image.path).lengthSync();
    int extensionIndex = filePath.lastIndexOf('.');
    if (extensionIndex != -1 && extensionIndex < filePath.length - 1) {
      imageExtension = filePath.substring(extensionIndex + 1);
    }
    var multipartFile = http.MultipartFile(
      'profile_pic',
      stream,
      length,
      filename: path.basename(image.path),
      contentType: MediaType('image', imageExtension), // Adjust the media type
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();

      user.profile_pic = json.decode(responseBody)["profile_pic"];
    } else {
      // Error handling
    }
  }

  static Future<void> editEmail(String Email, User user,
      Nutritionist nutritionist, bool UserType, BuildContext context) async {
    var userId;
    var token;
    if (UserType == true) {
      token = user.token;
      userId = user.id;
    } else {
      token = nutritionist.token;
      userId = nutritionist.id;
    }

    final url = URLIP + '/api/auth/editemail/$userId/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({"email": Email});

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 201) {
      final tokenPrefs = await SharedPreferences.getInstance();
      await tokenPrefs.setString(
          'auth_token', json.decode(utf8.decode(response.bodyBytes))["token"]);

      if (UserType == true) {
        user.email = json.decode(utf8.decode(response.bodyBytes))["email"];
        user.token = json.decode(utf8.decode(response.bodyBytes))["token"];
      } else {
        nutritionist.email =
            json.decode(utf8.decode(response.bodyBytes))["email"];
        nutritionist.token =
            json.decode(utf8.decode(response.bodyBytes))["token"];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          ' لقد تم تحديث البريد الاكتروني ',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  static Future<List<dynamic>> getAllNutritionist() async {
    var url = Uri.parse(URLIP + '/api/auth/getAllNutritionist/');
    http.Response response = await http.get(url);
    String val = response.body;
    List<dynamic> data = jsonDecode(val);

    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<List<dynamic>> getHighestNutritionist() async {
    var url = Uri.parse(URLIP + '/api/auth/getHighestNutritionist');
    http.Response response = await http.get(url);
    String val = response.body;
    List<dynamic> data = jsonDecode(val);

    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> getNutritionistInfo(
      int ID, String token) async {
    var url = Uri.parse(URLIP + '/api/auth/getNutritionistInformation/$ID/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response = await http.get(url, headers: headers);
    String val = response.body;

    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> getUserChatInfo(
      int ID, String token) async {
    var url = Uri.parse(URLIP + '/api/auth/getUserInfoChat/$ID/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response = await http.get(url, headers: headers);
    String val = response.body;

    return json.decode(utf8.decode(response.bodyBytes));
  }

  static String getImage(String image) {
    String img;
    try {
      img = image;
    } catch (e) {
      img = 'images/pers.png';
    }
    return img;
  }

  static Future<Map<String, dynamic>> getNutrionestAppointments(DateTime today,
      BuildContext context, nutrtionestId, bool UserType) async {
    final urlID =
        URLIP + '/appointment/getNutrtionistappointments/$nutrtionestId/';

    final headersID = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({"appointmentDate": today.toString().split(" ")[0]});
    final responseID =
        await http.post(Uri.parse(urlID), headers: headersID, body: body);

    if (responseID.statusCode != 400) {
      return jsonDecode(utf8.decode(responseID.bodyBytes));
    } else {
      if (UserType == true)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'لا يوجد مواعيد في هذا التاريخ',
            textAlign: TextAlign.center,
          )),
        );
      return {};
    }
  }

  static ReservationAppointments(
      BuildContext context,
      DateTime today,
      int selectedIndex,
      List<Map<String, bool>> appointmentsTime,
      int nutrtuinistId,
      String tokenval) async {
    final urlreserveappointment =
        URLIP + '/appointment/reserveAppointment/$nutrtuinistId/';

    final headersreservation = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };
    final body = jsonEncode({
      "appointmentReservationTime": appointmentsTime[selectedIndex]
          .keys
          .toString()
          .replaceAll('(', '')
          .replaceAll(')', ''),
      "appointmentReservationDate": today.toString().split(" ")[0]
    });

    final responseID = await http.put(Uri.parse(urlreserveappointment),
        headers: headersreservation, body: body);

    final dataBody = jsonDecode(utf8.decode(responseID.bodyBytes));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
        'تم حجز الموعد المختار',
        textAlign: TextAlign.center,
      )),
    );
  }

  static Future<void> NutritionistAppointmentSchedule(
      String token,
      BuildContext context,
      DateTime today,
      List<Map<String, dynamic>> time) async {
    final urlreserveappointment = URLIP + '/appointment/sch';

    final headersreservation = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "appointmentDate": today.toString().split(" ")[0],
      "appointmentTime": time
    });

    final responseData = await http.put(Uri.parse(urlreserveappointment),
        headers: headersreservation, body: body);
  }

  static Future<List<dynamic>> getAllProduct() async {
    var url = Uri.parse(URLIP + '/product/getAllProduct');
    http.Response response = await http.get(url);
    String val = response.body;
    List<dynamic> data = jsonDecode(val);

    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<List<dynamic>> getFavoriteNutritionist(String tokenval) async {
    var url = Uri.parse(URLIP + '/api/auth/getFavorite');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final response = await http.get(url, headers: headers);
    if (json.decode(utf8.decode(response.bodyBytes))["nutritionist"] == null) {
      return [];
    } else {
      return json.decode(utf8.decode(response.bodyBytes))["nutritionist"];
    }
  }

  static Future<void> addFavoriteNutritionist(
      String tokenval, int Nutritionistid) async {
    var url = Uri.parse(URLIP + '/api/auth/addFavorite/$Nutritionistid/');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final response = await http.put(url, headers: headers);
  }

  static Future<void> deleteFavoriteNutritionist(
      String tokenval, int Nutritionistid) async {
    var url = Uri.parse(URLIP + '/api/auth/deleteFavorite/$Nutritionistid/');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final response = await http.put(url, headers: headers);
  }

  static Future<List<dynamic>> getFavoriteProduct(String tokenval) async {
    var url = Uri.parse(URLIP + '/product/getFavorite');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final response = await http.get(url, headers: headers);
    if (json.decode(utf8.decode(response.bodyBytes))["product"] != null) {
      return json.decode(utf8.decode(response.bodyBytes))["product"];
    } else {
      return [];
    }
  }

  static Future<void> addFavoriteProduct(String tokenval, int productid) async {
    var url = Uri.parse(URLIP + '/product/addFavorite/$productid/');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final response = await http.put(url, headers: headers);
  }

  static Future<void> deleteFavoriteProduct(
      String tokenval, int productid) async {
    var url = Uri.parse(URLIP + '/product/deleteFavorite/$productid/');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final response = await http.put(url, headers: headers);
  }

  static Future<Map<String, dynamic>> updateUserInformation(
      BuildContext context,
      String? token,
      String fName,
      String lNmae,
      String year,
      String month,
      String day,
      int userId) async {
    final url = URLIP + '/api/auth/editinfo/$userId/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "user": {
        "first_name": fName,
        "last_name": lNmae,
        "date_of_birth":
            year.toString() + "-" + month.toString() + "-" + day.toString()
      }
    });

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تم تعديل بياناتك',
          textAlign: TextAlign.center,
        )),
      );

      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'حاول التأكد من البيانات المدخلة',
          textAlign: TextAlign.center,
        )),
      );
      return {};
    }
  }

  static Future<Map<String, dynamic>> updateNutritionistInformation(
      BuildContext context,
      String? token,
      String fName,
      String lNmae,
      String year,
      String month,
      String day,
      String phone_number,
      String collage,
      String Specialization,
      String experience_years,
      String description,
      String Price,
      int userId) async {
    final url = URLIP + '/api/auth/editNutritionistinfo/$userId/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final body = jsonEncode({
      "user": {
        "first_name": fName,
        "last_name": lNmae,
        "date_of_birth":
            year.toString() + "-" + month.toString() + "-" + day.toString()
      },
      "Price": int.parse(Price),
      "phone_number": int.parse(phone_number),
      "description": description,
      "experience_years": int.parse(experience_years),
      "collage": collage,
      "Specialization": Specialization
    });
    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تم تعديل بياناتك',
          textAlign: TextAlign.center,
        )),
      );

      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'حاول التأكد من البيانات المدخلة',
          textAlign: TextAlign.center,
        )),
      );
      return {};
    }
  }

  static Future<void> PutNCPAnswer(
      BuildContext context,
      String token,
      bool A1,
      bool A2,
      bool A3,
      bool A4,
      bool A5,
      bool A6,
      bool A7,
      String Q1,
      String Q2,
      String Q3,
      String Q4,
      String Q5,
      String Q6,
      String Q7) async {
    final url = URLIP + '/appointment/addAnswer';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "Answers": [
        {
          "Question": "Q1",
          "QuestionAnswer": A1,
          "AnswerDescription": A1 == true ? Q1 : ""
        },
        {
          "Question": "Q2",
          "QuestionAnswer": A2,
          "AnswerDescription": A2 == true ? Q2 : ""
        },
        {
          "Question": "Q3",
          "QuestionAnswer": A3,
          "AnswerDescription": A3 == true ? Q3 : ""
        },
        {
          "Question": "Q4",
          "QuestionAnswer": A4,
          "AnswerDescription": A4 == true ? Q4 : ""
        },
        {
          "Question": "Q5",
          "QuestionAnswer": A5,
          "AnswerDescription": A5 == true ? Q5 : ""
        },
        {
          "Question": "Q6",
          "QuestionAnswer": A6,
          "AnswerDescription": A6 == true ? Q6 : ""
        },
        {
          "Question": "Q7",
          "QuestionAnswer": A7,
          "AnswerDescription": A7 == true ? Q7 : ""
        }
      ]
    });
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تم تعديل بياناتك',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  static void resetPassword(String password1, String password2, String email,
      BuildContext context) async {
    final url = URLIP + '/api/auth/restPassword';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "email": email.toLowerCase(),
      "new_password1": password1,
      "new_password2": password2
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (json.decode(utf8.decode(response.bodyBytes))['massage'] ==
        "reset password done") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تم تغير كلمة المرور ',
          textAlign: TextAlign.center,
        )),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  static void reSendCode(String Email, BuildContext context) async {
    final url = URLIP + '/api/auth/sendverficationcode';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "email": Email.toLowerCase(),
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (json.decode(utf8.decode(response.bodyBytes))['error'] ==
        "No user found with that email address") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'الايمل المستخدم ليس مسجل ',
          textAlign: TextAlign.center,
        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تم اعادة ارسال الكود',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  static void sendCode(String Email, BuildContext context) async {
    final url = URLIP + '/api/auth/sendverficationcode';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "email": Email.toLowerCase(),
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (json.decode(utf8.decode(response.bodyBytes))['error'] ==
        "No user found with that email address") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'الايمل المستخدم ليس مسجل ',
          textAlign: TextAlign.center,
        )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgetPass2(
            Email: Email,
          ),
        ),
      );
    }
  }

  static Future<void> LogoutAPI(String token, int userId) async {
    String url = URLIP + '/api/auth/logout/$userId';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(Uri.parse(url), headers: headers);
  }

  static Future<List<dynamic>> getNutrtionestReservation(
      DateTime today, String token, BuildContext context) async {
    final urlID = URLIP + '/appointment/NutritionistReservation';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body =
        jsonEncode({"appointmentDate": today.toString().split(" ")[0]});
    final responseID =
        await http.post(Uri.parse(urlID), headers: headers, body: body);

    if (responseID.statusCode != 404) {
      return jsonDecode(utf8.decode(responseID.bodyBytes));
    } else {
      if (UserType == true)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'لا يوجد مواعيد في هذا التاريخ',
            textAlign: TextAlign.center,
          )),
        );
      return [];
    }
  }

  static Future<List<dynamic>> getUserReservation(
      DateTime today, String token, BuildContext context) async {
    final urlID = URLIP + '/appointment/userappointment';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body =
        jsonEncode({"appointmentDate": today.toString().split(" ")[0]});
    final responseID =
        await http.post(Uri.parse(urlID), headers: headers, body: body);

    if (responseID.statusCode != 404) {
      return jsonDecode(utf8.decode(responseID.bodyBytes));
    } else {
      if (UserType == true)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'لا يوجد مواعيد في هذا التاريخ',
            textAlign: TextAlign.center,
          )),
        );
      return [];
    }
  }

  static Future<List<dynamic>> getUserChatNutrtionest(
      String token, BuildContext context) async {
    final urlID = URLIP + '/appointment/userappointmentChat';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final responseID = await http.get(Uri.parse(urlID), headers: headers);

    if (responseID.statusCode != 404) {
      return jsonDecode(utf8.decode(responseID.bodyBytes));
    } else {
      if (UserType == true)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'لا يوجد اي رسائل',
            textAlign: TextAlign.center,
          )),
        );
      return [];
    }
  }

  static Future<List<dynamic>> getNutrtionestChat(
      String token, BuildContext context) async {
    final urlID = URLIP + '/appointment/nutritionestChat';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final responseID = await http.get(Uri.parse(urlID), headers: headers);

    if (responseID.statusCode != 404) {
      return jsonDecode(utf8.decode(responseID.bodyBytes));
    } else {
      if (UserType == false)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'لا يوجد رسائل ',
            textAlign: TextAlign.center,
          )),
        );
      return [];
    }
  }

  static Future<List<dynamic>> getUserDataChat(String token, int userId) async {
    final urlID = URLIP + '/appointment/getUserNCPdatacNU/$userId/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final responseID = await http.get(Uri.parse(urlID), headers: headers);

    return jsonDecode(utf8.decode(responseID.bodyBytes));
  }

  static Future<void> ChangeNutRating(
      String token, int Nu_Id, int rating) async {
    final url = URLIP + '/api/auth/changeNutritionistRating/$Nu_Id/';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "rating": rating,
    });

    final response =
        await http.patch(Uri.parse(url), headers: headers, body: body);
  }

  static Future<void> AddEditProduct(File image, String ProductName,
      String weight, String barcode, String email) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URLIP + '/product/addEditProduct'),
    );

    var filePath = image.path;
    if (filePath == null) {
      // Handle the case when filePath is null
      return;
    }
    var imageExtension = "";
    var stream = http.ByteStream(Stream.castFrom(File(image.path).openRead()));
    var length = File(image.path).lengthSync();
    int extensionIndex = filePath.lastIndexOf('.');
    if (extensionIndex != -1 && extensionIndex < filePath.length - 1) {
      imageExtension = filePath.substring(extensionIndex + 1);
    }
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: path.basename(image.path),
      contentType: MediaType('image', imageExtension), // Adjust the media type
    );

    request.files.add(multipartFile);
    request.fields["message"] = "اسم المنتج : " +
        ProductName +
        "\n وزن المنتج : " +
        weight +
        "\n رقم الباركود : " +
        barcode;
    request.fields["email"] = email;
    var response = await request.send();

    if (response.statusCode == 200) {
      // Image uploaded successfully
    } else {
      // Error handling
    }
  }

  static Future<void> HelpAndSupportAPI(String message, String email) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URLIP + '/product/helpAndSupport'),
    );

    request.fields["message"] = message;
    request.fields["email"] = email;
    var response = await request.send();

    if (response.statusCode == 200) {
      // Image uploaded successfully
    } else {
      // Error handling
    }
  }

  static Future<Map<String, dynamic>> GetProductInfoAPI(int barcode) async {
    final urlID = URLIP + '/product/getProduct';
    final headersID = {'Content-Type': 'application/json'};
    final body = jsonEncode({"barcode_number": barcode});
    final responseID =
        await http.post(Uri.parse(urlID), headers: headersID, body: body);

    if (responseID.statusCode != 400) {
      return jsonDecode(utf8.decode(responseID.bodyBytes));
    } else {
      return {};
    }
  }

  static Future<void> ChangePass(String token, String oldPass, String newPass1,
      String newPass2, BuildContext context) async {
    String url = URLIP + '/api/auth/ChangePassword';
    List<dynamic> Userdata = [];

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode({
      "old_password": oldPass,
      "new_password1": newPass1,
      "new_password2": newPass2
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تأكد من كلمات المرور التي ادخلتها ',
          textAlign: TextAlign.center,
        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'تم تغير كلمة المرور',
          textAlign: TextAlign.center,
        )),
      );
    }
  }

  static Future<List<dynamic>> getNCPdata(String token) async {
    String url = URLIP + '/appointment/getUserNCPInfo';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> getProductById(int product_id) async {
    String url = URLIP + '/product/getproductbyid/$product_id/';

    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(Uri.parse(url), headers: headers);
    return json.decode(utf8.decode(response.bodyBytes));
  }
}
