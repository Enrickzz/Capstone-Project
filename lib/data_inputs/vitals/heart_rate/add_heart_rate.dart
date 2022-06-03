import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/LocalNotifications.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_heart_rate extends StatefulWidget {
  final List<Heart_Rate> thislist;
  final String instance;
  add_heart_rate({this.thislist, this.instance});
  @override
  _add_heart_rateState createState() => _add_heart_rateState();
}
final _formKey = GlobalKey<FormState>();
class _add_heart_rateState extends State<add_heart_rate> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int beats = 0;
  String isResting = 'false';
  DateTime heartRateDate;
  String heartRate_date = (new DateTime.now()).toString();
  String heartRate_time;
  String hr_status ="";
  bool isDateSelected= false;
  int count = 1;
  List<Heart_Rate> heartRate_list = new List<Heart_Rate>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  var heartRateValue = TextEditingController();
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
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
                    'Add Heart Rate',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: heartRateValue,
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
                      hintText: "Number of Beats per minute?",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Number of Beats' : null,
                    onChanged: (val){

                      setState(() =>

                      beats = int.parse(val));
                    },
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Did you just finish exercising or performing strenuous physical activities?",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: "Yes",
                                groupValue: isResting,
                                onChanged: (value){
                                  setState(() {
                                    this.isResting = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Text("Yes"),
                          SizedBox(width: 16),
                          Radio(
                            value: "No",
                            groupValue: isResting,
                            onChanged: (value){
                              setState(() {
                                this.isResting = value;
                              });
                            },
                          ),
                          Text("No"),
                          SizedBox(width: 16)
                        ],
                      )
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
                        if(value != null && value != heartRateDate){
                          setState(() {
                            heartRateDate = value;
                            isDateSelected = true;
                            heartRate_date = "${heartRateDate.month}/${heartRateDate.day}/${heartRateDate.year}";
                          });
                          dateValue.text = heartRate_date + "\r";
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
                            heartRate_time = "$hours:$min";
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
                          Navigator.pop(context, widget.thislist);
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
                            final readHeartRate = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list');
                            readHeartRate.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Heart_Rate heartRate;
                              if(datasnapshot.value == null){
                                final heartRateRef = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/' + 1.toString());
                                if(isResting.toLowerCase() =='yes'){
                                  hr_status = "Active";
                                  print(hr_status + "<<< STATUS");
                                }
                                else{
                                  hr_status = "Resting";
                                  print(hr_status + "<<< STATUS");
                                }
                                heartRateRef.set({"HR_bpm": beats.toString(), "hr_status": hr_status, "hr_date": heartRate_date.toString(), "hr_time": heartRate_time.toString(), "new_hr": true});
                                print("Added Heart Rate Successfully! " + uid);

                              }
                              else{
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = heartRate_list.length--;
                                  print("count " + count.toString());
                                  if(isResting.toLowerCase() =='yes'){
                                    hr_status = "Active";
                                    print(hr_status + "<<< STATUS");

                                  }
                                  else{
                                    hr_status = "Resting";
                                    print(hr_status + "<<< STATUS");

                                  }
                                  final heartRateRef = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/' + count.toString());
                                  heartRateRef.set({"HR_bpm": beats.toString(), "hr_status": hr_status, "hr_date": heartRate_date.toString(), "hr_time": heartRate_time.toString(), "new_hr": true});
                                  print("Added Heart Rate Successfully! " + uid);
                                  if(beats < 40){
                                    print("ADDING NOW");
                                    final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                                    readConnections.once().then((DataSnapshot snapshot2) {
                                      print(snapshot2.value);
                                      print("CONNECTION");
                                      List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                      temp.forEach((jsonString) {
                                        connections.add(Connection.fromJson(jsonString)) ;
                                        Connection a = Connection.fromJson(jsonString);
                                        print(a.doctor1);
                                        addtoNotif("Your <type> "+ thisuser.firstname+ " has recorded a very low heart rate and requires your immediate medical attention",
                                            thisuser.firstname + " has very low heart rate!",
                                            "3",
                                            a.doctor1, "None");
                                      });
                                    });
                                  }
                                });

                              }

                            });
                            //Recommendations / Notifs
                            if(widget.instance =="Reminder!"){
                              if(beats > 100 && hr_status =="Resting"){
                                addtoRecommendation("We have informed your doctor and support system regarding your condition as your heart rate is still higher than the normal range. Please seek immediate medical atention if you are feeling unwell or take prescribed medications if your doctor has given you one. Please remain calm and try to compose yourself.",
                                    "High Heart Rate!",
                                    "3",
                                    uid,
                                    "None");
                                print("ADDING NOW");
                                final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                                readConnections.once().then((DataSnapshot snapshot2) {
                                  print(snapshot2.value);
                                  print("CONNECTION");
                                  List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                  temp.forEach((jsonString) {
                                    connections.add(Connection.fromJson(jsonString)) ;
                                    Connection a = Connection.fromJson(jsonString);
                                    print(a.doctor1);
                                    addtoNotif("Your <type> "+ thisuser.firstname+ " has recorded a high heart rate and requires your immediate medical attention",
                                        thisuser.firstname + " has consecutive high heart rate readings",
                                        "3",
                                        a.doctor1,
                                        "None");
                                  });
                                });
                              }
                            }
                            print(beats.toString() + "<<<< BEATS");
                            if(isResting.toLowerCase() =='yes'){
                              hr_status = "Active";
                              print(hr_status + "<<< STATUS");

                            }
                            else{
                              hr_status = "Resting";
                              print(hr_status + "<<< STATUS");
                            }
                            // void schedHRtake() async{
                            //   print("SCHED THIS");
                            //   final cron = Cron()
                            //     ..schedule(Schedule.parse('* * */1 * * * '), () {
                            //       addtoNotif("Check your Heart Rate again now now. Click me to check now!", "Reminder!", "1", uid, "HeartRate");
                            //       print("after 1 hr");
                            //     });
                            //   await Future.delayed(Duration( hours: 1, minutes: 3));
                            //   await cron.close();
                            // }
                            if(beats < 40){
                              addtoNotif("Your Heart Rate is alarming which is why we have already notified your doctor and support system regarding this. Please remain calm at all times and seek immediate medical attention.",
                                  "High Heart Rate!",
                                  "2",
                                  uid,"None");
                              print("ADDING NOW");
                              final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                              readConnections.once().then((DataSnapshot snapshot2) {
                                print(snapshot2.value);
                                print("CONNECTION");
                                List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                temp.forEach((jsonString) {
                                  connections.add(Connection.fromJson(jsonString)) ;
                                  Connection a = Connection.fromJson(jsonString);
                                  print(a.doctor1);
                                  addtoNotif("Your <type> "+ thisuser.firstname+ " has recorded a very low heart rate and requires your immediate medical attention",
                                      thisuser.firstname + " has very low heart rate!",
                                      "3",
                                      a.doctor1, "None");
                                });
                              });
                            }
                            if(beats > 100 && hr_status == "Resting"){
                              addtoRecommendation("We recommend that you record your heart rate again after an hour since your heart rate is higher than the normal range. We have set an alarm for you to record your heart rate again later  If you are feeling unwell please seek immediate medical attention. For the meantime we advise you to keep yourself calm and listen to some relaxing music while managing your breathing.",
                                  "Heart Rate is High!",
                                  "2",
                                  uid, "Spotify");
                              NotificationService ns = NotificationService("hr");
                              await ns.init().then((value) async {
                                await ns.scheduleNotifications(Duration(hours: 2));
                              });
                              // schedHRtake();
                            }
                            if(beats > 100 && hr_status == "Active"){
                              addtoRecommendation("Your heart rate seems a bit high but since you just finished exercising. If you feel unwell please don’t hesitate to seek immediate medical attention. We recommend that you record your heart rate again after an hour as we would be setting a reminder for you to do so. For the meantime please listen to some soothing music while you take a rest and relax yourself.",
                                  "Heart Rate is High!",
                                  "2",
                                  uid, "Spotify");
                            }
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + heartRate_list.length.toString());
                              heartRate_list.add(new Heart_Rate(bpm: beats, hr_status: hr_status, hr_date: format.parse(heartRate_date),hr_time: timeformat.parse(heartRate_time)));
                              for(var i=0;i<heartRate_list.length/2;i++){
                                var temp = heartRate_list[i];
                                heartRate_list[i] = heartRate_list[heartRate_list.length-1-i];
                                heartRate_list[heartRate_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, heartRate_list);
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
  bool parseBool(String temp) {
    if (temp.toLowerCase() == 'yes') {
      return false;
    } else if (temp.toLowerCase() == 'no') {
      return true;
    }
    else{
      print("error parsing bool");
    }
  }
  void getHeartRate() {
    heartRate_list.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readHR = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/');
    readHR.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        heartRate_list.add(Heart_Rate.fromJson(jsonString));
      });
    });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect) async {
    print ("ADDED TO NOTIFICATIONS");
    notifsList.clear();
    await getNotifs(uid).then((value) {
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
    });
  }
  Future<void> getNotifs(String uid) async{
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void addtoRecommendation(String message, String title, String priority, String uid,String redirect){
    getRecomm(uid);
    final ref = databaseReference.child('users/' + uid + '/recommendations/');
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        ref.set({"id": 0.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + recommList.length.toString());
        ref.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});

      }
    });
  }
  void getRecomm(String uid) {
    print("GET RECOM");
    recommList.clear();
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }

  void initNotif() {
    getHeartRate();
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
    getRecomm(uid);
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }
}
