import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:project/Services/services.dart';
import 'package:project/screens/NutritionistInfoPage.dart';
import 'package:project/screens/UserInfoPage.dart';
import 'package:project/screens/home.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/Services/services.dart';
import 'package:project/models/Nutritionist.dart';
import 'package:project/models/User.dart';
import 'Massages.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int id = 0;

class Chat_screen extends StatefulWidget {
  final reciver_id;
  const Chat_screen({Key? key, required this.reciver_id}) : super(key: key);

  @override
  State<Chat_screen> createState() => _Chat_screenState();
}

class _Chat_screenState extends State<Chat_screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _messages = <String>[];
  final _senderid = <int>[];
  final _messageTime = <String>[];
  final _messageDate = <String>[];
  final _messageType = <String>[];
  late final WebSocketChannel _channel;
  final _messageController = TextEditingController();
  final _messageFocus = FocusNode();
  final _scrollController = ScrollController();
  bool isActive = true;
  bool _needsScroll = false;

  Map<String, dynamic>? ReciverInfo;

  Box? _userBox;
  User user = User.empty();
  Nutritionist nutritionist = Nutritionist.empty();
  Box? _nutritionistBox;
  bool UserType = true;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future _openBox() async {
    final userTypePrefs = await SharedPreferences.getInstance();
    UserType = (await userTypePrefs.getBool('user_type'))!;

    _userBox = await Hive.box('UserBox');
    _nutritionistBox = await Hive.box('NutritionistBox');
    setState(() {
      if (UserType == true) {
        user = _userBox?.get('UserBox');
        id = user.id;
      } else {
        nutritionist = _nutritionistBox?.get('NutritionistBox');
        id = nutritionist.id;
      }
    });
    if (UserType == true) {
      getNutInfo();
    } else {
      getUserInfo();
    }

    return;
  }

  void getNutInfo() {
    RestAPIConector.getNutritionistInfo(widget.reciver_id, user.token)
        .then((responseBody) {
      setState(() {
        ReciverInfo = responseBody;
      });
      _createConnection();
      getMassages();
    });
  }

  void getUserInfo() {
    RestAPIConector.getUserChatInfo(widget.reciver_id, nutritionist.token)
        .then((responseBody) {
      setState(() {
        ReciverInfo = responseBody;
      });
      _createConnection();
      getMassages();
    });
  }

  void getMassages() async {
    Uri uri = Uri.parse(RestAPIConector.URLIP);
    String authority = uri.authority;
    final urlID = RestAPIConector.URLIP + '/msg/chatmsg/${widget.reciver_id}/';
    final tokenval = UserType == true ? user.token : nutritionist.token;

    final headersID = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenval'
    };

    final responseID = await http.get(Uri.parse(urlID), headers: headersID);
    final dataBody = jsonDecode(utf8.decode(responseID.bodyBytes));
    for (int i = dataBody.length - 1; i >= 0; i--) {
      setState(() {
        dataBody[i]["massage"] == null
            ? _messages.add(dataBody[i]["image"])
            : _messages.add(dataBody[i]["massage"]);
        _senderid.add(dataBody[i]["sender"]);
        _messageTime.add(dataBody[i]["timestamp"]
                .toString()
                .split("T")[1]
                .split(".")[0]
                .split(":")[0] +
            "-" +
            dataBody[i]["timestamp"]
                .toString()
                .split("T")[1]
                .split(".")[0]
                .split(":")[1]);
        _messageDate.add(dataBody[i]["timestamp"].toString().split("T")[0]);
        _messageType.add(dataBody[i]["type"]);
        _needsScroll = true;
      });
    }
  }

  void _createConnection() async {
    Uri uri = Uri.parse(RestAPIConector.URLIP);
    String authority = uri.authority;
    final tokenval = UserType == true ? user.token : nutritionist.token;
    _channel = IOWebSocketChannel.connect(
      Uri.parse('ws://192.168.1.8:8000/ws/socket-server/${widget.reciver_id}/'),
      headers: {
        'Authorization': 'Bearer $tokenval',
      },
    );

    // to save messages
    _channel.stream.listen(
        (message) => setState(() {
              if (jsonDecode(message)["type"] == "text") {
                _messages.add(jsonDecode(message)["message"]);
                _senderid.add(jsonDecode(message)["sender_id"]);
                _messageTime.add(jsonDecode(message)["time"]);
                _messageDate.add(jsonDecode(message)["date"]);
                _messageType.add(jsonDecode(message)["type"]);
                _scrollToEnd();
              } else if (jsonDecode(message)["type"] == "image_message") {
                _messages.add(
                    RestAPIConector.URLIP + jsonDecode(message)["message"]);
                _senderid.add(jsonDecode(message)["sender_id"]);
                _messageTime.add(jsonDecode(message)["time"]);
                _messageDate.add(jsonDecode(message)["date"]);
                _messageType.add(jsonDecode(message)["type"]);
                _scrollToEnd();
              }
            }),
        onError: (error) => setState(() => _messages.add('Error: $error')));
  }

  _scrollToEnd() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  void _send() {
    if (_messageController.text.isNotEmpty) {
      var _sendmsg = {"message": _messageController.text, "type": "text"};
      _channel.sink.add(jsonEncode(_sendmsg));
      _messageController.text = '';
    }
    _messageFocus.requestFocus();
  }

  void _attachPicture() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageData = await pickedFile.readAsBytes();
      final String imageUrl = base64Encode(imageData);
      // Send the image URL in the chat
      Map<String, dynamic> imgmessage = {
        'type': 'image_upload',
        'image': imageUrl,
      };
      _channel.sink.add(jsonEncode(imgmessage));
    }
  }

  void _showUserInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoPage(user_id: widget.reciver_id),
      ),
    );
  }

  void _showNutritionistInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionistInfoPage(user_id: widget.reciver_id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 0),
                width: 60,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'رجوع',
                    style:
                        GoogleFonts.robotoCondensed(color: Colors.deepPurple),
                  ),
                ),
              ),
              // Show the button for normal users only
              Padding(
                padding: EdgeInsets.only(right: 120),
                child: GestureDetector(
                  onTap: UserType == true
                      ? _showNutritionistInfoPage
                      : _showUserInfoPage,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color:
                          Colors.deepPurple, // Set your deep purple color here
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info,
                      color: Colors.white, // Set the icon color to white
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ReciverInfo != null
                        ? ReciverInfo!["user"]["username"].toString()
                        : "",
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: isActive
                    ? Image.asset('images/greencircle.png')
                    : Image.asset('images/greycircle.png'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: ClipOval(
                      child: Image.network(
                        RestAPIConector.getImage(RestAPIConector.URLIP +
                            (ReciverInfo != null
                                ? (ReciverInfo!["user"]["profile_pic"] != null
                                    ? ReciverInfo!["user"]["profile_pic"]
                                    : "")
                                : "")),
                        errorBuilder: ((context, error, stackTrace) =>
                            Image.asset(
                              'images/imgprofile.png',
                              height: 50,
                              width: 50,
                            )),
                        width: 50, // Set the desired width
                        height: 50, // Set the desired height
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        //------------------- Body ---------------------------

        body: Container(
          color: Color(0XF4F4F4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ChatBubblesScrollView(
                  scrollController: _scrollController,
                  messages: _messages,
                  senderid: _senderid,
                  messageTime: _messageTime,
                  messageDate: _messageDate,
                  messageType: _messageType,
                  userType: UserType,
                  imageperson: UserType == true
                      ? user.profile_pic
                      : nutritionist.profile_pic,
                  imageSender: (ReciverInfo != null
                      ? (ReciverInfo!["user"]["profile_pic"] != null
                          ? ReciverInfo!["user"]["profile_pic"]
                          : "")
                      : ""),
                ),
              ),
              ChatMessageSubmitForm(
                messageFocus: _messageFocus,
                messageController: _messageController,
                send: () => _send(),
                attachPicture: _attachPicture,
              )
            ],
          ),
        ));
  }
}

class ChatMessageSubmitForm extends StatelessWidget {
  const ChatMessageSubmitForm({
    Key? key,
    required this.messageFocus,
    required this.messageController,
    required this.send,
    required this.attachPicture,
  }) : super(key: key);

  final FocusNode messageFocus;
  final TextEditingController messageController;
  final void Function() send;
  final void Function() attachPicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              focusNode: messageFocus,
              decoration: const InputDecoration(
                  alignLabelWithHint: true, label: Text('اكتب رسالة . . .')),
              controller: messageController,
              onSubmitted: (_) => send(),
            )),
            const SizedBox(width: 20),
            IconButton(
              onPressed: attachPicture,
              icon: Icon(Icons.attach_file),
              color: Colors.deepPurple, // Set the icon color to deep purple
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            ElevatedButton(onPressed: () => send(), child: const Text('إرسال')),
          ],
        ),
      ),
    );
  }
}

// view all messages as bubbles messages
class ChatBubblesScrollView extends StatelessWidget {
  const ChatBubblesScrollView({
    Key? key,
    required ScrollController scrollController,
    required List<String> messages,
    required List<int> senderid,
    required List<String> messageDate,
    required List<String> messageTime,
    required List<String> messageType,
    required bool userType,
    required String imageperson,
    required String imageSender,
  })  : _scrollController = scrollController,
        _messages = messages,
        _senderid = senderid,
        _messageTime = messageTime,
        _messageDate = messageDate,
        _messageType = messageType,
        _UserType = userType,
        _ImagePerson = imageperson,
        _ImageSender = imageSender,
        super(key: key);

  final ScrollController _scrollController;
  final List<String> _messages;
  final List<int> _senderid;
  final List<String> _messageDate;
  final List<String> _messageTime;
  final List<String> _messageType;
  final bool _UserType;
  final String _ImagePerson;
  final String _ImageSender;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _messages.length,
      controller: _scrollController,
      itemBuilder: (context, index) => Bubble(
          _messages[index],
          _senderid[index],
          _messageTime[index],
          _messageDate[index],
          _messageType[index],
          _ImagePerson,
          _ImageSender),
    );
  }
}

class Bubble extends StatefulWidget {
  Bubble(this.message, this.senderid, this.messageTime, this.messageDate,
      this.messageType, this.ImagePerson, this.ImageSender,
      {Key? key})
      : super(key: key);
  final String message;
  final int senderid;
  final String messageTime;
  final String messageDate;
  final String messageType;
  final String ImagePerson;
  final String ImageSender;
  @override
  State<Bubble> createState() => _BubbleScreen();
}

class _BubbleScreen extends State<Bubble> {
  static final DateTime now = DateTime.now();
  static final intl.DateFormat formatterDate = intl.DateFormat('MM-dd-YYYY');
  final String formattedDate = formatterDate.format(now);
  static final intl.DateFormat formatterTime = intl.DateFormat('HH:mm');
  final String formattedTime = formatterTime.format(now);
  final String dateStr = now.toString();

  double _scale = 0.8;
  double _previousScale = 0.8;
  Offset _offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                widget.messageTime == formattedTime
                    ? "now"
                    : widget.messageTime,
                style: TextStyle(fontSize: 12, color: Colors.black45),
              )),
          Row(
            mainAxisAlignment: id == widget.senderid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Wrap(
                spacing:
                    16.0, // Set horizontal spacing between the child widgets
                runSpacing:
                    16.0, // Set vertical spacing between the rows of child widgets
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.horizontal,
                textDirection: id == widget.senderid
                    ? TextDirection.rtl
                    : TextDirection.ltr,

                children: <Widget>[
                  Container(
                    margin: id == widget.senderid
                        ? EdgeInsets.only(right: 10, top: 20)
                        : EdgeInsets.only(left: 10, top: 20),
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ]),
                    child: ClipOval(
                      child: Image.network(
                        RestAPIConector.getImage(RestAPIConector.URLIP +
                            (id == widget.senderid
                                ? widget.ImagePerson
                                : widget.ImageSender)),
                        errorBuilder: ((context, error, stackTrace) =>
                            Image.asset(
                              'images/imgprofile.png',
                              height: 30,
                              width: 30,
                            )),
                        width: 30, // Set the desired width
                        height: 30, // Set the desired height
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    alignment: id == widget.senderid
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: id == widget.senderid
                              ? Colors.deepPurple.shade300.withOpacity(0.4)
                              : Colors.black26,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]),
                      child: widget.messageType == "text"
                          ? Text(
                              widget.message,
                              style: GoogleFonts.robotoCondensed(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            )
                          : GestureDetector(
                              onScaleStart: (details) {
                                _previousScale = _scale;
                              },
                              onScaleUpdate: (details) {
                                setState(() {
                                  _scale = _previousScale * details.scale;
                                });
                              },
                              onScaleEnd: (details) {
                                setState(() {
                                  _scale = 1.0;
                                });
                              },
                              child: GestureDetector(
                                  onScaleStart: (details) {
                                    _previousScale = _scale;
                                    setState(() {});
                                  },
                                  onScaleUpdate: (details) {
                                    _scale = _previousScale * details.scale;
                                    _offset = details.focalPoint;
                                    setState(() {});
                                  },
                                  onScaleEnd: (details) {
                                    _previousScale = 1.0;
                                    setState(() {});
                                  },
                                  child: Transform(
                                      transform:
                                          Matrix4.diagonal3Values(1, 1, 0.5),
                                      child: Container(
                                          child: Image.network(
                                        RestAPIConector.getImage(
                                            widget.message),
                                        fit: BoxFit
                                            .contain, // Set the image fit mode
                                      )))),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
