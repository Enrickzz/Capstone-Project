import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_water_intake extends StatefulWidget {
  // final List<Body_Temperature> btlist;
  // add_water_intake({this.btlist});
  @override
  add_waterIntakeState createState() => add_waterIntakeState();
}
final _formKey = GlobalKey<FormState>();
class add_waterIntakeState extends State<add_water_intake> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int water_intake = 0;
  String unit = 'Milimeter';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String waterintake_date = (new DateTime.now()).toString();
  DateTime waterintakeDate;
  String waterintake_time;
  String indication = "";
  bool isDateSelected= false;
  int count = 1;
  Water_Goal water_goal = new Water_Goal();
  List<WaterIntake> waterintake_list = new List<WaterIntake>();
  Physical_Parameters pp = new Physical_Parameters();
  Additional_Info info = new Additional_Info();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List <bool> isSelected = [true, false];

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  @override
  void initState(){
    initNotif();
    super.initState();
  }

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
                    'Log Water Intake',
                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width:0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize),
                            hintText: "Water Intake",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Water Intake' : null,
                          onChanged: (val){
                            setState(() => water_intake = int.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 8,),
                      ToggleButtons(
                        isSelected: isSelected,
                        highlightColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        children: <Widget> [
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Milliliter (ml)')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Ounce (oz)')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelected.length; index++){
                              if (index == newIndex) {
                                isSelected[index] = true;
                                print('Milliliter (ml)');
                              } else {
                                isSelected[index] = false;
                                print("Ounce (oz)");
                              }
                            }
                            if(newIndex == 0){
                              print('Milliliter (ml)');
                              unit = "Milliliter";
                              print(unit);
                            }
                            if(newIndex == 1){
                              print("Ounce (oz)");
                              unit = "Ounce";
                              print(unit);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime.now().subtract(Duration(days: 30)),
                          lastDate: new DateTime.now(),
                      ).then((value){
                        if(value != null && value != waterintakeDate){
                          setState(() {
                            waterintakeDate = value;
                            isDateSelected = true;
                            waterintake_date = "${waterintakeDate.month.toString().padLeft(2,"0")}/${waterintakeDate.day.toString().padLeft(2,"0")}/${waterintakeDate.year}";
                          });
                          dateValue.text = waterintake_date + "\r";
                        }
                      });

                      final initialTime = TimeOfDay(hour:12, minute: 0);
                      await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: TimeOfDay.now().hour,
                            minute: (TimeOfDay.now().minute - TimeOfDay.now().minute % 10 + 10)
                                .toInt()),
                      ).then((value){
                        if(value != null && value != time){
                          setState(() {
                            time = value;
                            final hours = time.hour.toString().padLeft(2,'0');
                            final min = time.minute.toString().padLeft(2,'0');
                            waterintake_time = "$hours:$min";
                            dateValue.text += "$hours:$min";
                            print("data value " + dateValue.text);
                          });
                        }
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateValue,
                        showCursor: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width:0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "Date and Time",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select Date and Time' : null,
                        onChanged: (val){

                          print(dateValue);
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
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
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readWaterIntake = databaseReference.child('users/' + uid + '/goal/water_intake/');
                            final readWaterGoal = databaseReference.child('users/' + uid + '/goal/water_goal/');
                            if(unit == "Ounce"){
                              String temp = "";
                              temp = (water_intake * 29.5735).toStringAsFixed(0);
                              water_intake = int.parse(temp);
                            }
                            readWaterIntake.once().then((DataSnapshot datasnapshot) {
                                if(datasnapshot.value == null){
                                  final waterintakeRef = databaseReference.child('users/' + uid + '/goal/water_intake/' + count.toString());
                                  waterintakeRef.set({"water_intake": water_intake.toString(), "dateCreated": waterintake_date,"timeCreated": waterintake_time});
                                  print("Added Water Intake Successfully! " + uid);

                                  if(water_intake >= 1500){
                                    print(">1500");
                                    final readAddinf = databaseReference.child("users/"+ uid+"/vitals/additional_info");
                                    readAddinf.once().then((DataSnapshot snapshot) {
                                      Additional_Info userInfo = Additional_Info.fromJson(jsonDecode(jsonEncode(snapshot.value)));
                                      bool check2 = false;
                                      print(snapshot.value);
                                      for(var i = 0; i < userInfo.other_disease.length; i++){
                                        if(userInfo.other_disease[i].contains("Heart Failure")) check2 = true;
                                      }
                                      for(var i = 0 ; i < userInfo.disease.length ; i++ ){
                                        if(userInfo.disease[i].contains("Heart Failure") ){
                                          check2 = true;
                                        }
                                      }
                                      if(check2 ==true ){
                                        addtoRecommendation("The recommended daily water intake for patients with congestive heart failure is 1500 milliliter a day. You have already exceeded the threshold for today. Please limit your water intake for the rest of the day.",
                                            "Limit your water",
                                            "3",
                                            "None",
                                            "Immediate");
                                      }
                                    });
                                  }
                                }
                                else{
                                  getWaterIntake();
                                  double totalWater = 0;
                                  DateTime now = DateTime.now();
                                  String datenow = "${now.month.toString().padLeft(2, "0")}/${now.day.toString().padLeft(2, "0")}/${now.year}";
                                  Future.delayed(const Duration(milliseconds: 1000), (){
                                    for(int i=0; i < waterintake_list.length; i++){
                                      String datecreated = "${waterintake_list[i].dateCreated.month.toString().padLeft(2, "0")}/${waterintake_list[i].dateCreated.day.toString().padLeft(2,"0")}/${waterintake_list[i].dateCreated.year}";
                                      if(datenow == datecreated){
                                        totalWater += waterintake_list[i].water_intake;
                                      }
                                    }
                                    totalWater = totalWater + water_intake;
                                    count = waterintake_list.length--;
                                    final waterintakeRef = databaseReference.child('users/' + uid + '/goal/water_intake/' + count.toString());
                                    waterintakeRef.set({"water_intake": water_intake.toString(), "dateCreated": waterintake_date,"timeCreated": waterintake_time});
                                    print("Added Water Intake Successfully! " + uid);
                                    if(totalWater >= 1500){
                                      print(">1500");
                                      final readAddinf = databaseReference.child("users/"+ uid+"/vitals/additional_info");
                                      readAddinf.once().then((DataSnapshot snapshot) {
                                        Additional_Info userInfo = Additional_Info.fromJson(jsonDecode(jsonEncode(snapshot.value)));
                                        bool check2 = false;
                                        print(snapshot.value);
                                        for(var i = 0; i < userInfo.other_disease.length; i++){
                                          if(userInfo.other_disease[i].contains("Heart Failure")) check2 = true;
                                        }
                                        for(var i = 0 ; i < userInfo.disease.length ; i++ ){
                                          if(userInfo.disease[i].contains("Heart Failure") ){
                                            check2 = true;
                                          }
                                        }
                                        if(check2 ==true ){
                                          addtoRecommendation("The recommended daily water intake for patients with congestive heart failure is 1500 milliliter a day. You have already exceeded the threshold for today. Please limit your water intake for the rest of the day.",
                                              "Limit your water",
                                              "3",
                                              "None",
                                              "Immediate");
                                        }
                                      });
                                    }
                                  });

                                }
                                readWaterGoal.once().then((DataSnapshot weightgoalsnapshot) {
                                  Map<String, dynamic> temp3 = jsonDecode(jsonEncode(weightgoalsnapshot.value));
                                  print(temp3);
                                  water_goal = Water_Goal.fromJson(temp3);
                                });

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              waterintake_list.add(new WaterIntake(water_intake: water_intake, timeCreated: timeformat.parse(waterintake_time), dateCreated: format.parse(waterintake_date)));
                              for(var i=0;i<waterintake_list.length/2;i++){
                                var temp = waterintake_list[i];
                                waterintake_list[i] = waterintake_list[waterintake_list.length-1-i];
                                waterintake_list[waterintake_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, waterintake_list);
                            });

                          } catch(e) {
                            print("you got an error! $e");
                          }
                          // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )
    );
  }
  void getNotifs2(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null)
        temp.forEach((jsonString) {
          notifsList.add(RecomAndNotif.fromJson(jsonString));
        });
    });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect){
    print ("ADDED TO NOTIFICATIONS");
    getNotifs2(uid);
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "heartrate", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "heartrate", "redirect": redirect});
      }
    });
  }
  void addtoRecommendation(String message, String title, String priority, String redirect,String category){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": category, "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": category, "redirect": redirect});
      }
    });
  }
  void getRecomm() {
    recommList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });
    });
  }
  void getWaterIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWaterIntake = databaseReference.child('users/' + uid + '/goal/water_intake/');
    readWaterIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        waterintake_list.add(WaterIntake.fromJson(jsonString));
      });
    });
  }
  // void getIndication() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final readAddInfo = databaseReference.child('users/' + uid + '/vitals/additional_info/');
  //   int age;
  //   readAddInfo.once().then((DataSnapshot snapshot) {
  //     Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
  //     print("temp2");
  //     print(temp2);
  //     info = Additional_Info.fromJson2(temp2);
  //     age = getAge(info.birthday);
  //
  //     if(unit == "Fahrenheit"){
  //       temperature = (temperature - 32) * 5/9;
  //       unit = "Celsius";
  //     }
  //     /// NORMAL
  //     double highest = 0;
  //     /// infant 0 - 10
  //     if(age <= 10 && age >= 0){
  //       if(temperature >= 35.5 && temperature <= 37.5){
  //         indication = "normal";
  //       }
  //       highest = 37.5;
  //     }
  //     /// 11 - 65
  //     if(age <= 65 && age >= 11){
  //       if(temperature >= 36.4 && temperature <= 37.6){
  //         indication = "normal";
  //       }
  //       highest = 37.6;
  //     }
  //     /// 65 above
  //     if(age > 65){
  //       if(temperature >= 35.8 && temperature <= 36.9){
  //         indication = "normal";
  //       }
  //       highest = 36.9;
  //     }
  //     /// LOW GRADE FEVER
  //     if(temperature >= highest && temperature <= 38){
  //       indication = "low grade fever";
  //     }
  //     /// HIGH GRADE FEVER
  //     if(temperature > 38){
  //       indication = "high grade fever";
  //     }
  //
  //   });
  // }

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
}