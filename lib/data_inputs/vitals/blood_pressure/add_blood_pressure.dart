import 'dart:convert';
import 'dart:math';

import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/LocalNotifications.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/blood_pressure_patient_view.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../../notifications/notifications._patients.dart';
import '../../laboratory_results/lab_results_patient_view.dart';
import '../../medicine_intake/medication_patient_view.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_blood_pressure extends StatefulWidget {
  final List<Blood_Pressure> thislist;
  final String instance;
  add_blood_pressure({this.thislist, this.instance});
  @override
  _add_blood_pressureState createState() => _add_blood_pressureState();
}
final _formKey = GlobalKey<FormState>();
class _add_blood_pressureState extends State<add_blood_pressure> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String systolic_pressure = '';
  String diastolic_pressure = '';
  String pressure_level = "";
  DateTime bpDate;
  String bp_time;
  String bp_date = (new DateTime.now()).toString();
  String bp_status = "";
  int count = 1;
  bool isDateSelected= false;
  List<Blood_Pressure> bp_list = new List<Blood_Pressure>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();
  bool isLoading = true;


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
                    'Add Blood Pressure',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),

                  DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TabBar(
                          labelColor: Colors.black,
                          tabs: <Widget>[
                            Tab(
                              text: "Manual Input",
                            ),
                            Tab(
                              text: "iHealth",
                            )
                          ],
                        ),
                        Container(
                          height: 314,
                          padding: EdgeInsets.only(top: 20),
                          child: TabBarView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
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
                                            hintText: "Systolic Pressure",
                                          ),
                                          validator: (val) => val.isEmpty ? 'Enter Systolic Pressure' : null,
                                          onChanged: (val){
                                            setState(() => systolic_pressure = val);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Text('/'),
                                      SizedBox(width: 8.0),
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
                                            hintText: "Diastolic Pressure",
                                          ),
                                          validator: (val) => val.isEmpty ? 'Enter Diastolic Pressure' : null,
                                          onChanged: (val){
                                            setState(() => diastolic_pressure = val);
                                          },
                                        ),
                                      ),
                                    ],
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
                                        if(value != null && value != bpDate){
                                          setState(() {
                                            bpDate = value;
                                            isDateSelected = true;
                                            bp_date = "${bpDate.month}/${bpDate.day}/${bpDate.year}";
                                          });
                                          dateValue.text = bp_date + "\r";
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
                                            bp_time = "$hours:$min";
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
                                            final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list');
                                            readBP.once().then((DataSnapshot datasnapshot) {
                                              String temp1 = datasnapshot.value.toString();
                                              print("temp1 " + temp1);
                                              List<String> temp = temp1.split(',');
                                              Blood_Pressure bloodPressure;
                                              if(datasnapshot.value == null){
                                                if(isResting.toLowerCase() =='yes'){
                                                  bp_status = "Active";
                                                }
                                                else{
                                                  bp_status = "Resting";
                                                }
                                                if(int.parse(systolic_pressure) < 90 || int.parse(diastolic_pressure) < 60){
                                                  pressure_level = "low";
                                                  print(pressure_level);
                                                }
                                                else if (int.parse(systolic_pressure) <= 120 && int.parse(systolic_pressure) >= 90 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                                  pressure_level = "normal";
                                                  print(pressure_level);
                                                }
                                                else if (int.parse(systolic_pressure) <= 129 && int.parse(systolic_pressure) >= 120 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                                  pressure_level = "elevated";
                                                  print(pressure_level);
                                                }
                                                else if (int.parse(systolic_pressure) > 130  || int.parse(diastolic_pressure) > 80){
                                                  pressure_level = "high";
                                                  print(pressure_level);
                                                }
                                                final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + count.toString());
                                                bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),"pressure_level": pressure_level.toString(),  "bp_date": bp_date.toString(), "bp_time":bp_time.toString(), "bp_status": bp_status.toString(), "new_bp": true});
                                                print("Added medication Successfully! " + uid);
                                              }
                                              else{
                                                if(isResting.toLowerCase() =='yes'){
                                                  bp_status = "Active";
                                                }
                                                else{
                                                  bp_status = "Resting";
                                                }
                                                if(int.parse(systolic_pressure) < 90 || int.parse(diastolic_pressure) < 60){
                                                  pressure_level = "low";
                                                  print(pressure_level);
                                                }
                                                else if (int.parse(systolic_pressure) <= 120 && int.parse(systolic_pressure) >= 90 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                                  pressure_level = "normal";
                                                  print(pressure_level);
                                                }
                                                else if (int.parse(systolic_pressure) <= 129 && int.parse(systolic_pressure) >= 120 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                                  pressure_level = "elevated";
                                                  print(pressure_level);
                                                }
                                                else if (int.parse(systolic_pressure) >= 130  || int.parse(diastolic_pressure) > 80){
                                                  pressure_level = "high";
                                                  print(pressure_level);
                                                }
                                                Future.delayed(const Duration(milliseconds: 1500), (){
                                                  count = bp_list.length--;
                                                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + count.toString());
                                                  bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),"pressure_level": pressure_level.toString(),  "bp_date": bp_date.toString(), "bp_time":bp_time.toString(), "bp_status": bp_status.toString(), "new_bp": true});
                                                  print("Added Blood Pressure Successfully! " + uid);
                                                });
                                              }
                                            });
                                            Future.delayed(const Duration(milliseconds: 1000), () async{
                                              print("MEDICATION LENGTH: " + bp_list.length.toString());
                                              String message, title;
                                              int priority;
                                              bp_list.add(new Blood_Pressure(systolic_pressure: systolic_pressure, diastolic_pressure: diastolic_pressure,pressure_level: pressure_level, bp_date: format.parse(bp_date), bp_time: timeformat.parse(bp_time), bp_status: bp_status.toString()));
                                              for(var i=0;i<bp_list.length/2;i++){
                                                var temp = bp_list[i];
                                                bp_list[i] = bp_list[bp_list.length-1-i];
                                                bp_list[bp_list.length-1-i] = temp;
                                              }
                                              if(isResting.toLowerCase() =='yes'){
                                                bp_status = "Active";
                                              }
                                              else{
                                                bp_status = "Resting";
                                              }
                                              if(int.parse(systolic_pressure) < 90 || int.parse(diastolic_pressure) < 60){
                                                pressure_level = "low";
                                                print(pressure_level);
                                              }
                                              else if (int.parse(systolic_pressure) <= 120 && int.parse(systolic_pressure) >= 90 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                                pressure_level = "normal";
                                                print(pressure_level);
                                              }
                                              else if (int.parse(systolic_pressure) <= 129 && int.parse(systolic_pressure) >= 120 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                                pressure_level = "elevated";
                                                print(pressure_level);
                                              }
                                              else if (int.parse(systolic_pressure) > 130  || int.parse(diastolic_pressure) > 80){
                                                pressure_level = "high";
                                                print(pressure_level);
                                              }
                                              // recommendations / notifs

                                              // void schedBP() async{
                                              //   print("SCHED THIS");
                                              //   final cron = Cron()
                                              //     ..schedule(Schedule.parse('*/50 * * * * '), () {
                                                    addtoNotif("Check your Blood Pressure again now. Click me to check now!", "Reminder!", "1", uid, "Blood Pressure");
                                              //       print("after 1 hr");
                                              //     });
                                              //   await Future.delayed(Duration( hours: 1, minutes: 3));
                                              //   await cron.close();
                                              // }
                                              if(widget.instance =="Reminder!"){
                                                addtoRecommendation("Your Blood Pressure is still high just like the previous recording. We have already informed your doctor and support system about this. Please seek immediate medical attention for this.",
                                                    "High Blood Pressure",
                                                    "3",
                                                    "None");
                                                if(pressure_level == "high" && bp_status =="Resting"){
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
                                                      addtoNotif2("Your <type> "+ thisuser.firstname+ " has recorded consecutive high blood pressure. This may require your immediate medical attention.",
                                                          thisuser.firstname + " has consecutive high BP readings",
                                                          "3",
                                                          a.doctor1);
                                                    });
                                                  });
                                                }
                                              }
                                              if(pressure_level == "high" && bp_status =="Resting"){
                                                addtoRecommendation("Your Blood Pressure is quite high, we recommend that you monitor your blood pressure for the next hour as we would set an alarm for you to record your blood pressure again. If you feel unwell please seek immediate medical attention for your condition. For the meantime here is a relaxing music for you to listen to while you are taking a breather. ",
                                                    "High Blood Pressure!",
                                                    "2", "Spotify");
                                                //sched needs new entry notif reference schedBP();
                                                NotificationService ns = NotificationService("bp");
                                                await ns.init().then((value) async {
                                                  await ns.scheduleNotifications(Duration(hours: 1));
                                                });
                                                // schedBP();
                                              }
                                              if(pressure_level == "high" && bp_status =="Active"){
                                                addtoRecommendation("Your Blood Pressure is quite high but since you just finished performing strenuous physical activities this is not immediately a cause for concern. We recommend that you take a rest and record your Blood Pressure again after an hour. For the meantime here are some soothing relaxing music to listen to while you are taking a rest.",
                                                    "High Blood Pressure!",
                                                    "4", "Spotify");
                                                //sched needs new entry notif reference schedBP();
                                                NotificationService ns = NotificationService("bp");
                                                await ns.init().then((value) async {
                                                  await ns.scheduleNotifications(Duration(hours: 1));
                                                });
                                                // schedBP();
                                              }
                                              if(pressure_level == "low"){
                                                addtoRecommendation("Your Blood pressure is lower than the normal standards, please record your heart rate and respiratory rate as well to have a better view of your current health.",
                                                    "Low Blood Pressure!",
                                                    "3", "None");
                                              }
                                              Navigator.pop(context, bp_list);
                                              print("POP HERE ==========");
                                            });
                                          } catch(e) {
                                            print("you got an error! $e");
                                          }
                                          // Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset("assets/images/bpdevice.jpg", height: 125,),

                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Connect your iHealth device',
                                      style: TextStyle(
                                          fontSize: 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32,),
                                  Center(
                                    child: ElevatedButton(
                                      child: Text("Connect"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(246,115,0,1),
                                        onPrimary: Colors.white,
                                        minimumSize: Size(100, 40),
                                      ),

                                      onPressed: (){
                                        final User user = auth.currentUser;
                                        final uid = user.uid;
                                        var rng = Random();
                                        int sys = rng.nextInt(10) + 120;
                                        int dia = rng.nextInt(10) + 70;
                                        count = bp_list.length--;
                                        DateTime now = new DateTime.now();
                                        final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + count.toString());
                                        bpRef.set({"systolic_pressure": sys.toString(), "diastolic_pressure": dia.toString(),"pressure_level": "normal",  "bp_date": now.month.toString().padLeft(2,'0')+"/"+now.day.toString().padLeft(2,'0')+"/"+now.year.toString(), "bp_time":now.hour.toString().padLeft(2,'0')+":"+now.minute.toString().padLeft(2,'0').toString(), "bp_status": "Resting".toString(), "new_bp": true});
                                        _showMyDialog();
                                      },
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
                                    ],
                                  ),

                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                ]
            )
        )

    );
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect){
    print ("ADDED TO NOTIFICATIONS");
    getNotifs3(uid);
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "blood pressure", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "blood pressure", "redirect": redirect});

      }
    });
  }
  void getNotifs3(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void addtoNotif2(String message, String title, String priority,String uid){
    print ("ADDED TO NOTIFICATIONS");
    getNotifs2(uid);
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    String redirect = "";
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});

      }
    });
  }
  void addtoNotifs(String message, String title, String priority){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    getNotifs();
    String redirect= "";
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": bp_time.toString(), "rec_date": bp_date.toString(), "category": "bloodpressure", "redirect": redirect});
      }else{
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + (notifsList.length--).toString());
        notifRef.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority,
          "rec_time": bp_time.toString(), "rec_date": bp_date.toString(), "category": "bloodpressure", "redirect": redirect});

      }
    });
  }
  void getNotifs2(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void addtoRecommendation(String message, String title, String priority, String redirect){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": bp_time.toString(), "rec_date": bp_date.toString(), "category": "bprecommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": bp_time.toString(), "rec_date": date, "category": "bprecommend", "redirect": redirect});
      }
    });
  }
  void getBloodPressure() {
    bp_list.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bp_list.add(Blood_Pressure.fromJson(jsonString));
      });
    });
  }
  void getNotifs() {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
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
    getBloodPressure();

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

  Future<void> _showMyDialog() async {
    Future.delayed(const Duration(milliseconds: 2000),() {
      setState(() {
        isLoading = false;
      });
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children:  <Widget>[
                Text('Waiting for your device to connect...'),
                isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                ): new Text("HELLO")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
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