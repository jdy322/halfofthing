import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/styles.dart';
import 'user_chat_page.dart';

class User_Create_page extends StatefulWidget {
  @override
  _User_Create_pageState createState() => _User_Create_pageState();
}

class _User_Create_pageState extends State<User_Create_page> {
  final GlobalKey<FormState> _restaurantFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final TextEditingController _restaurantController =
      TextEditingController(); //컨트롤러 생성

  @override
  void dispose() {
    _restaurantController.dispose();
    super.dispose();
  }

  String _restaurant;
  String _time;

  String _userPhoneNumber;
  String _userLocation;

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        _userLocation = prefs.getString('prefsLocation');
      });
    })();
  }

//  int _selectedMenuNumber = 0;

//  List<String> _selectedMenu = ['미선택', '한식', '중식', '일식', '분식', '음료', '패스트푸드'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                '반띵할 사람이 생기면 알림으로 알려드려요',
                style: text_grey_15(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                child: Form(
                  key: _restaurantFormKey,
                  child: TextFormField(
                    onChanged: (String str) {
                      setState(() {
                        _restaurant = str;
                      });
                    },
                    keyboardType: TextInputType.text,
                    controller: _restaurantController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.restaurant),
                        hintText: '식당 이름',
                        border: InputBorder.none),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '식당 이름을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          '받을 시간',
                          style: text_grey_15(),
                        ),
                      ],
                    ),
                    Flexible(
                      child: TimePickerSpinner(
                        is24HourMode: true,
                        normalTextStyle: text_grey_15(),
                        highlightedTextStyle: text_pink_20(),
                        spacing: 20,
                        itemHeight: 50,
                        itemWidth: 40,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            _time = DateFormat('HH시 mm분').format(time);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_restaurantFormKey.currentState.validate()) {
                var _currentTime = DateTime.now();
                var _userOrderId =
                    DateFormat('yyyyMMddHHmmss').format(_currentTime);
                Firestore.instance
                    .collection('게시판')
                    .document(
                    _userPhoneNumber +
                        '_' +
                        _userOrderId)
                    .setData({
                  '식당이름': _restaurant,
                  '주문시간': _time,
                  '위치': _userLocation,
                  '개설자핸드폰번호': _userPhoneNumber,
                  '참가자핸드폰번호': '',
                  '게시판이름': _userPhoneNumber +
                      '_' +
                      _userOrderId,
                  '채팅중': 'Y',
                });
                _restaurantController.clear();
                Fluttertoast.showToast(
                    msg: '새로운 반띵이 등록되었어요',
                    gravity: ToastGravity
                        .CENTER,
                    backgroundColor:
                    Colors.pink,
                    textColor:
                    Colors.white);
              }else {}
            },
            child: Padding(
              padding:
              const EdgeInsets.only(left: 40, right: 40, bottom: 20),
              child: Card(
                color: Colors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 15,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: Container(
                      height: 50,
                      child: Center(
                          child: Text(
                            '반띵하기',
                            style: text_white_20(),
                          ))),
                ),
              ),
            ),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => User_Chat_Page()));
//                    },
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)),
//                      elevation: 5,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 25, right: 25, top: 15, bottom: 15),
//                        child: Center(
//                            child: Text(
//                          _selectedMenu[1],
//                          style: text_black_20(),
//                        )),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    height: 10,
//                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => User_Chat_Page()));
//                    },
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)),
//                      elevation: 5,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 25, right: 25, top: 15, bottom: 15),
//                        child: Center(
//                            child: Text(
//                          _selectedMenu[2],
//                          style: text_black_20(),
//                        )),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    height: 10,
//                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => User_Chat_Page()));
//                    },
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)),
//                      elevation: 5,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 25, right: 25, top: 15, bottom: 15),
//                        child: Center(
//                            child: Text(
//                          _selectedMenu[3],
//                          style: text_black_20(),
//                        )),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => User_Chat_Page()));
//                    },
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)),
//                      elevation: 5,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 25, right: 25, top: 15, bottom: 15),
//                        child: Center(
//                            child: Text(
//                          _selectedMenu[4],
//                          style: text_black_20(),
//                        )),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    height: 10,
//                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => User_Chat_Page()));
//                    },
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)),
//                      elevation: 5,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 25, right: 25, top: 15, bottom: 15),
//                        child: Center(
//                            child: Text(
//                          _selectedMenu[5],
//                          style: text_black_20(),
//                        )),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    height: 10,
//                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => User_Chat_Page()));
//                    },
//                    child: Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20)),
//                      elevation: 5,
//                      color: Colors.white,
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            left: 25, right: 25, top: 15, bottom: 15),
//                        child: Center(
//                            child: Text(
//                          _selectedMenu[6],
//                          style: text_black_20(),
//                        )),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ],
//          ),
        ],
      ),
    );
  }
}

Widget Chatstart(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '메뉴 :',
                    style: TextStyle(color: Colors.brown),
                    textScaleFactor: 1,
                  ),
                  Container(
                    width: 10,
                  ),
                ],
              ),
              Container(
                height: 40,
              ),
              Text(
                '반띵을 시작하시겠습니까?',
                style: TextStyle(color: Colors.brown),
                textScaleFactor: 1,
              ),
              Container(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '취소',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
}
