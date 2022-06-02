import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_vitals_prescription extends StatefulWidget {
  final List<Vitals> thislist;
  String userUID;
  add_vitals_prescription({this.thislist, this.userUID});
  @override
  _addVitalsrescriptionState createState() => _addVitalsrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addVitalsrescriptionState extends State<add_vitals_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateFormat format = new DateFormat("MM/dd/yyyy");
  int count = 1;
  List<Vitals> vitals_list = new List<Vitals>();

  String purpose = "";
  int frequency = 1;
  String type;
  String important_notes = "";
  String prescribedBy = "";
  DateTimeRange dateRange;
  DateTime now =  DateTime.now();
  List<String> listVitals = <String>[
    'Blood Pressure', 'Blood Glucose','Oxygen Saturation', 'Body Temperature'
    ,'Heart Rate', 'Respiratory Rate'

  ];

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users doctor = new Users();
  Users patient = new Users();
  bool notifier = true;
  String reason_notification = "";
  bool checkboxValue = false;

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
                    'Add Vitals Recording Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
                    showCursor: true,
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
                      hintText: "Purpose",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Purpose Field' : null,
                    onChanged: (val){
                      setState(() => purpose = val);
                    },
                  ),

                  SizedBox(height: 8.0),
                  DropdownButtonFormField(
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
                      hintText: "Vital",
                    ),
                    isExpanded: true,
                    value: type,
                    onChanged: (newValue){
                      setState(() {
                        type = newValue;
                      });

                    },
                    items: listVitals.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),

                  SizedBox(height: 16.0),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Record how many times a day?",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: frequency,
                                onChanged: (value){
                                  setState(() {
                                    this.frequency = value;
                                  });
                                },
                              ),
                              Text("1"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: frequency,
                                onChanged: (value){
                                  setState(() {
                                    this.frequency = value;
                                  });
                                },
                              ),
                              Text("2"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: frequency,
                                onChanged: (value){
                                  setState(() {
                                    this.frequency = value;
                                  });
                                },
                              ),
                              Text("3"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: frequency,
                                onChanged: (value){
                                  setState(() {
                                    this.frequency = value;
                                  });
                                },
                              ),
                              Text("4"),
                            ],
                          ),
                          SizedBox(width: 3)
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 8.0),

                  TextFormField(
                    maxLines: 6,
                    showCursor: true,
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
                      hintText: "Important Notes/Assessments",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Special Instructions' : null,
                    onChanged: (val){
                      setState(() => important_notes = val);
                    },
                  ),
                  FormField<bool>(
                    builder: (state) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                  value: checkboxValue,
                                  onChanged: (bool b) {
                                    setState(() {
                                      checkboxValue = b;
                                    });
                                  }),
                              Text("Notify lead doctor"),
                            ],
                          ),

                        ],
                      );
                    },
                  ),
                  Visibility(
                    visible: checkboxValue,
                    child: Column(
                      children: [
                        TextFormField(
                          showCursor: true,
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
                            hintText: "Reason for notifying",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter reason for notifying' : null,
                          onChanged: (val){
                            setState(() => reason_notification = val);
                          },
                        ),
                      ],
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
                            String doctorName = "";
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            String vitalType = "";
                            final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
                            Users doctor = new Users();
                            readDoctor.once().then((DataSnapshot snapshot) {
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                              doctor = Users.fromJson(temp);
                              doctorName = doctor.firstname + " " + doctor.lastname;
                            });
                            final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/vitals_plan/');
                            readFoodPlan.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              if(datasnapshot.value == null){
                                final vitalsRef = databaseReference.child('users/' + userUID + '/management_plan/vitals_plan/' + count.toString());
                                vitalsRef.set({"purpose": purpose.toString(), "type": type.toString(), "frequency": frequency, "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctorName});
                                print("Added Vitals Plan Successfully! " + uid);
                                final connectionRef = databaseReference.child('users/' + userUID + '/vitals_connection/');
                                if(type == "Blood Pressure"){
                                  vitalType = "bloodpressure";
                                }
                                else if(type == "Blood Glucose"){
                                  vitalType = "bloodglucose";
                                }
                                else if(type == "Heart Rate"){
                                  vitalType = "heartrate";
                                }
                                else if(type == "Respiratory Rate"){
                                  vitalType = "respiratoryrate";
                                }
                                else if(type == "Oxygen Saturation"){
                                  vitalType = "oxygensaturation";
                                }
                                else if(type == "Body Temperature"){
                                  vitalType = "bodytemperature";
                                }
                                connectionRef.update({"$vitalType": "true"});
                              }
                              else{
                                getVitals();
                                final connectionRef = databaseReference.child('users/' + userUID + '/vitals_connection/');
                                if(type == "Blood Pressure"){
                                  vitalType = "bloodpressure";
                                }
                                else if(type == "Blood Glucose"){
                                  vitalType = "bloodglucose";
                                }
                                else if(type == "Heart Rate"){
                                  vitalType = "heartrate";
                                }
                                else if(type == "Respiratory Rate"){
                                  vitalType = "respiratoryrate";
                                }
                                else if(type == "Oxygen Saturation"){
                                  vitalType = "oxygensaturation";
                                }
                                else if(type == "Body Temperature"){
                                  vitalType = "bodytemperature";
                                }
                                connectionRef.update({"$vitalType": "true"});
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = vitals_list.length--;
                                  final vitalsRef = databaseReference.child('users/' + userUID + '/management_plan/vitals_plan/' + count.toString());
                                  vitalsRef.set({"purpose": purpose.toString(), "type": type.toString(), "frequency": frequency, "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctorName});
                                  print("Added Food Plan Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), () async{
                              print("MEDICATION LENGTH: " + vitals_list.length.toString());
                              vitals_list.add(new Vitals(purpose: purpose, type: type,frequency: frequency, important_notes: important_notes, prescribedBy: uid, dateCreated: now, doctor_name: doctorName));
                              for(var i=0;i<vitals_list.length/2;i++){
                                var temp = vitals_list[i];
                                vitals_list[i] = vitals_list[vitals_list.length-1-i];
                                vitals_list[vitals_list.length-1-i] = temp;
                              }
                              Vitals newV = new Vitals(purpose: purpose, type: type,frequency: frequency, important_notes: important_notes, prescribedBy: uid, dateCreated: now, doctor_name: doctorName);
                              await getNotifs(widget.userUID).then((value) {
                                addtoNotif("Dr. "+doctor.lastname+ " has added something to your vitals management plan. Click here to view your new Food management plan. " ,
                                    "Doctor Added to your Vitals Plan!",
                                    "1",
                                    "Vitals Plan",
                                    widget.userUID);
                              });

                              if(checkboxValue == true){
                                notifyLead(userUID, reason_notification, doctor.lastname, "Vitals");
                              }
                              Navigator.pop(context,newV);
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
  void notifyLead(String userUID, String reasonNotification, String doctorLastName, String planType){
    final connections = databaseReference.child('users/' + userUID + '/personal_info/lead_doctor/' );
    connections.once().then((DataSnapshot snapConnections) async {
      String temp = jsonDecode(jsonEncode(snapConnections.value));
      String leadDoc = temp.toString();
      //ADD NOTIF LOGIC =
      await getNotifs(leadDoc).then((value) {
        addtoNotif("Dr. "+doctorLastName+ " has added something to your patient's $planType management plan. He notes: "+reasonNotification ,
            "Doctor"+ doctorLastName + "Added to your patient's $planType Plan!",
            "1",
            "$planType Plan",
            leadDoc);
      });

    });
    //notifyLead(userUID, reason_notification, doctor.lastname, "Exer");
  }
  void addtoNotif(String message, String title, String priority,String redirect, String uid){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
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
  Future<void> getNotifs(String passedUid) async {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = passedUid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
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
        doctor = Users.fromJson(temp);
      });
      final readPatient = databaseReference.child('users/' + widget.userUID + '/personal_info/');
      readPatient.once().then((DataSnapshot snapshotPatient) {
        Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
        patientTemp.forEach((key, jsonString) {
          patient = Users.fromJson(patientTemp);
        });
        Future.delayed(const Duration(milliseconds: 200), (){
          if(patient.leaddoctor == uid){
            setState(() {
              notifier = false;
            });
          }else notifier= true;
        });
      });
    });
  }
  void getVitals() {
    // final User user = auth.currentUser;
    // final uid = user.uid;

    String userUID = widget.userUID;
    final readVitals = databaseReference.child('users/' + userUID + '/management_plan/vitals_plan/');
    readVitals.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print("temp");
      print(temp);
      temp.forEach((jsonString) {
        vitals_list.add(Vitals.fromJson(jsonString));
      });
    });
  }
}