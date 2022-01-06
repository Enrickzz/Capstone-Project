import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/blood_pressure_patient_view.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import 'package:duration_picker/duration_picker.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class change_sleep_goal extends StatefulWidget {
  // final List<Body_Temperature> btlist;
  // add_water_intake({this.btlist});
  @override
  change_sleepGoalState createState() => change_sleepGoalState();
}
final _formKey = GlobalKey<FormState>();
class change_sleepGoalState extends State<change_sleep_goal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double temperature = 0;
  String unit = 'Celsius';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String temperature_date = (new DateTime.now()).toString();
  DateTime temperatureDate;
  String temperature_time;
  String indication = "";
  bool isDateSelected= false;
  int count = 1;
  List<Body_Temperature> body_temp_list = new List<Body_Temperature>();
  Additional_Info info = new Additional_Info();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List <bool> isSelected = [true, false];

  Duration _duration = Duration(hours: 0, minutes: 0);


  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
        key: _formKey,
        color:Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
                topRight:Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Sleep Goal',
                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),

                  Text(
                    'Please input new sleep goal duration',
                    style: TextStyle( fontSize: 14),
                  ),
                  SizedBox(height: 12.0),


                  DurationPicker(
                    duration: _duration,
                    onChange: (val) {
                      setState(() => _duration = val);
                    },
                    snapToMins: 5.0,
                  ),




                  SizedBox(height: 24.0),
                  // DropdownButton(
                  //   hint: Text("Select items:"),
                  //   dropdownColor: Colors.grey,
                  //   icon: Icon(Icons.arrow_drop_down),
                  //   iconSize: 36,
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //   ),
                  //   value: valueChoose,
                  //   onChanged:(value) {
                  //     setState(() {
                  //       valueChoose = value;
                  //     });
                  //   },
                  //   items: degrees.map((valueItem) {
                  //     return DropdownMenuItem(
                  //         value: valueItem,
                  //         child: Text(valueItem),
                  //     );
                  //   })
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Proceed',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:()  {
                          _showMyDialogDelete();

                        },
                      )
                    ],
                  ),

                ]
            )
        )
    );
  }
  void getBodyTemp() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBT = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/');
    readBT.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        body_temp_list.add(Body_Temperature.fromJson(jsonString));
      });
    });
  }
  void getIndication() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readAddInfo = databaseReference.child('users/' + uid + '/vitals/additional_info/');
    int age;
    readAddInfo.once().then((DataSnapshot snapshot) {
      Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
      print("temp2");
      print(temp2);
      info = Additional_Info.fromJson2(temp2);
      age = getAge(info.birthday);

      if(unit == "Fahrenheit"){
        temperature = (temperature - 32) * 5/9;
        unit = "Celsius";
      }
      /// NORMAL
      double highest = 0;
      /// infant 0 - 10
      if(age <= 10 && age >= 0){
        if(temperature >= 35.5 && temperature <= 37.5){
          indication = "normal";
        }
        highest = 37.5;
      }
      /// 11 - 65
      if(age <= 65 && age >= 11){
        if(temperature >= 36.4 && temperature <= 37.6){
          indication = "normal";
        }
        highest = 37.6;
      }
      /// 65 above
      if(age > 65){
        if(temperature >= 35.8 && temperature <= 36.9){
          indication = "normal";
        }
        highest = 36.9;
      }
      /// LOW GRADE FEVER
      if(temperature >= highest && temperature <= 38){
        indication = "low grade fever";
      }
      /// HIGH GRADE FEVER
      if(temperature > 38){
        indication = "high grade fever";
      }

    });
  }

  int getAge (DateTime birthday) {
    DateTime today = new DateTime.now();
    String days1 = "";
    String month1 = "";
    String year1 = "";
    int d = int.parse(DateFormat("dd").format(birthday));
    int m = int.parse(DateFormat("MM").format(birthday));
    int y = int.parse(DateFormat("yyyy").format(birthday));
    int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));
    int age = 0;
    age = y1 - y;
    print(age);

    // dec < jan
    if(m1 < m){
      print("month --");
      age--;
    }
    else if (m1 == m){
      if(d1 < d){
        print("day --");
        age--;
      }
    }
    return age;
  }
  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Water Intake Goal'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("Water is essential to good health and helps prevent dehydration. While water needs vary from person to person, we often need at laest 1893 ml or 64 oz of water a day.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                print('Save');
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}