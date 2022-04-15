import 'dart:convert';

import 'package:cron/cron.dart';
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
import '../../laboratory_results/lab_results_patient_view.dart';
import '../../medicine_intake/medication_patient_view.dart';
import 'o2_saturation_patient_view.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_o2_saturation extends StatefulWidget {
  final List<Oxygen_Saturation> o2list;
  final String instance;
  add_o2_saturation({this.o2list, this.instance});
  @override
  _add_o2_saturationState createState() => _add_o2_saturationState();
}
final _formKey = GlobalKey<FormState>();
class _add_o2_saturationState extends State<add_o2_saturation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int spo2 = 0;
  bool isDateSelected= false;
  DateTime oxygenDate;
  String oxygen_date = (new DateTime.now()).toString();
  String oxygen_time = "";
  String oxygen_status = "";
  int count = 0;
  List<Oxygen_Saturation> oxygen_list = new List<Oxygen_Saturation>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
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
                    'Add Oxygen Saturation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
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
                          height: 313,
                          padding: EdgeInsets.only(top: 20),
                          child: TabBarView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  TextFormField(
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
                                      hintText: "Oxygen Saturation (%SpO2)",
                                    ),
                                    validator: (val) => val.isEmpty ? 'Enter Oxygen Saturation (%SpO2)' : null,
                                    onChanged: (val){
                                      setState(() => spo2 = int.parse(val));
                                    },
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
                                        if(value != null && value != oxygenDate){
                                          setState(() {
                                            oxygenDate = value;
                                            isDateSelected = true;
                                            oxygen_date = "${oxygenDate.month}/${oxygenDate.day}/${oxygenDate.year}";
                                          });
                                          dateValue.text = oxygen_date + "\r";
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
                                            oxygen_time = "$hours:$min";
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
                                  SizedBox(height: 119.0),
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
                                            final readOxygen = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list');
                                            readOxygen.once().then((DataSnapshot datasnapshot) {
                                              String temp1 = datasnapshot.value.toString();
                                              print("temp1 " + temp1);
                                              List<String> temp = temp1.split(',');
                                              Oxygen_Saturation oxygen;
                                              if(spo2 < 90){
                                                oxygen_status = "critical";
                                              }
                                              else if(spo2 >= 90 && spo2 <= 95){
                                                oxygen_status = "alarming";
                                              }
                                              else if (spo2 > 95 && spo2 <= 100){
                                                oxygen_status = "normal";
                                              }
                                              else {
                                                oxygen_status = "error";
                                              }
                                              if(datasnapshot.value == null){
                                                final oxygenRef = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/' + 0.toString());
                                                oxygenRef.set({"oxygen_saturation": spo2.toString(),"oxygen_status": oxygen_status.toString(), "os_date": oxygen_date.toString(), "os_time": oxygen_time.toString()});
                                                print("Added Oxygen Saturation Successfully! " + uid);
                                              }
                                              else{
                                                // String tempOxygen = "";
                                                // String tempOxygenStatus = "";
                                                // String tempOxygenDate = "";
                                                // String tempOxygenTime = "";
                                                //
                                                // for(var i = 0; i < temp.length; i++){
                                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                                //   List<String> splitFull = full.split(" ");
                                                //   switch(i%4){
                                                //     case 0: {
                                                //       tempOxygen = splitFull.last;
                                                //     }
                                                //     break;
                                                //     case 1: {
                                                //       tempOxygenDate = splitFull.last;
                                                //     }
                                                //     break;
                                                //     case 2: {
                                                //       tempOxygenStatus = splitFull.last;
                                                //     }
                                                //     break;
                                                //     case 3: {
                                                //       tempOxygenTime = splitFull.last;
                                                //       oxygen = new Oxygen_Saturation(oxygen_saturation: int.parse(tempOxygen),oxygen_status: tempOxygenStatus, os_date: format.parse(tempOxygenDate), os_time: timeformat.parse(tempOxygenTime));
                                                //       oxygen_list.add(oxygen);
                                                //     }
                                                //     break;
                                                //   }
                                                // }
                                                getOxygenSaturation();
                                                Future.delayed(const Duration(milliseconds: 1000), (){
                                                  count = oxygen_list.length--;
                                                  print("count " + count.toString());
                                                  //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                                  // symptoms_list.add(symptom);

                                                  // print("symptom list  " + symptoms_list.toString());
                                                  final oxygenRef = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/' + count.toString());
                                                  oxygenRef.set({"oxygen_saturation": spo2.toString(),"oxygen_status": oxygen_status.toString(), "os_date": oxygen_date.toString(), "os_time": oxygen_time.toString()});
                                                  print("Added Oxygen Saturation Successfully! " + uid);
                                                });

                                              }

                                            });
                                            //RECOMMEND AND NOTIFS
                                            void schedOxy() async{
                                              print("SCHED OXY");
                                              final cron = Cron()
                                                ..schedule(Schedule.parse('* */30 * * * * '), () {
                                                  addtoNotif("Check your Oxygen Saturation now", "Reminder!", "1", uid, "oxygen");
                                                  print("ADD");
                                                });
                                              await Future.delayed(Duration(  minutes: 35));
                                              await cron.close();
                                            }
                                            if(widget.instance =="Reminder!"){
                                              if(spo2 < 95){
                                                addtoNotif("We recommend that you seek immediate medical attention as we have informed your doctor and support system regarding your condition. Please remain calm and stay composed and continue to monitor your other vitals such as blood pressure and heart rate.",
                                                    "Low Oxygen!",
                                                    "3",
                                                    uid,
                                                    "None");
                                                final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                                                readConnections.once().then((DataSnapshot snapshot2) {
                                                  print(snapshot2.value);
                                                  print("CONNECTION");
                                                  List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                                  temp.forEach((jsonString) {
                                                    connections.add(Connection.fromJson(jsonString)) ;
                                                    Connection a = Connection.fromJson(jsonString);
                                                    print(a.doctor1);
                                                    addtoNotif("Your <type> "+ thisuser.firstname+ " has recorded a consistent oxygen rate between 90 - 95 and requires your medical attention",
                                                        thisuser.firstname + " has consecutive low SPO2 readings",
                                                        "3",
                                                        a.doctor1,
                                                        "None");
                                                  });
                                                });
                                              }
                                            }
                                            if(spo2 < 90){
                                              addtoRecommendation("We recommend that you seek immediate medical attention as we have informed your doctor and support system regarding your condition. You or someone else near you must administer an immediate oxygen supply as your body is lacking oxygen right now. ",
                                                  "Low Oxygen Levels!",
                                                  "3",
                                                  uid,
                                                  "None");
                                              final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                                              readConnections.once().then((DataSnapshot snapshot2) {
                                                print(snapshot2.value);
                                                print("CONNECTION");
                                                List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                                temp.forEach((jsonString) {
                                                  connections.add(Connection.fromJson(jsonString)) ;
                                                  Connection a = Connection.fromJson(jsonString);
                                                  print(a.doctor1);
                                                  addtoNotif("Your <type> "+ thisuser.firstname+ " has recorded a oxygen rate of 90 and requires your immediate medical attention",
                                                      thisuser.firstname + " has low SPO2 readings",
                                                      "3",
                                                      a.doctor1,
                                                      "None");
                                                });
                                              });
                                            }
                                            if(spo2 >= 91 && spo2 <= 95){
                                              addtoRecommendation("Your Oxygen Saturation is lower than normal but is still not a cause to be alarmed. We recommend that you record your oxygen saturation again after 30 minutes. For the meantime try to remain calm and perform deep breathing as you listen to some soothing spotify songs.",
                                                  "Low Oxygen Levels",
                                                  "2",
                                                  uid,
                                                  "Spotify");
                                              schedOxy();
                                            }

                                            Future.delayed(const Duration(milliseconds: 1000), (){
                                              print("MEDICATION LENGTH: " + oxygen_list.length.toString());
                                              oxygen_list.add(new Oxygen_Saturation(oxygen_saturation: spo2,oxygen_status: oxygen_status, os_date: format.parse(oxygen_date), os_time: timeformat.parse(oxygen_time)));
                                              for(var i=0;i<oxygen_list.length/2;i++){
                                                var temp = oxygen_list[i];
                                                oxygen_list[i] = oxygen_list[oxygen_list.length-1-i];
                                                oxygen_list[oxygen_list.length-1-i] = temp;
                                              }
                                              print("POP HERE ==========");
                                              Navigator.pop(context, oxygen_list);
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
                                    child: Image.asset("assets/images/osdevice.png", height: 125,),

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
  void getOxygenSaturation() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readOS = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/');
    readOS.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        oxygen_list.add(Oxygen_Saturation.fromJson(jsonString));
      });
    });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect){
    print ("ADDED TO NOTIFICATIONS");
    getNotifs(uid);
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "oxygen", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "oxygen", "redirect": redirect});

      }
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
  void getNotifs(String uid) {
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
    getRecomm(uid);
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children:  <Widget>[
                Text('Waiting for your device to connect...'),
                SizedBox(height: 25,),
                SizedBox(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(246,115,0,1))),
                  height: 50.0,
                  width: 50.0,
                ),
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