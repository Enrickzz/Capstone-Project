import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/Symptoms/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms.dart';
import '../../fitness_app_theme.dart';
import 'add_blood_glucose.dart';
import 'add_blood_pressure.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class blood_glucose extends StatefulWidget {
  final List<Blood_Glucose> bglist;
  blood_glucose({Key key, this.bglist}): super(key: key);
  @override
  _blood_glucoseState createState() => _blood_glucoseState();
}

class _blood_glucoseState extends State<blood_glucose> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Glucose> bgtemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  @override
  void initState() {
    super.initState();
      bgtemp.clear();
      getBloodGlucose();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    // final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list');
    // String tempGlucose = "";
    // String tempStatus = "";
    // String tempGlucoseStatus = "";
    // String tempGlucoseDate = "";
    // String tempGlucoseTime = "";
    // readMedication.once().then((DataSnapshot datasnapshot) {

    //   String temp1 = datasnapshot.value.toString();
    //   print("temp1 " + temp1);
    //   List<String> temp = temp1.split(',');
    //   Blood_Glucose bloodGlucose;
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //     switch(i%5){
    //       case 0: {
    //         tempGlucose = splitFull.last;
    //       }
    //       break;
    //       case 1: {
    //         tempGlucoseTime = splitFull.last;
    //       }
    //       break;
    //       case 2: {
    //         tempStatus = splitFull.last;
    //       }
    //       break;
    //       case 3: {
    //         tempGlucoseStatus = splitFull.last;
    //       }
    //       break;
    //       case 4: {
    //         tempGlucoseDate = splitFull.last;
    //         bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), bloodGlucose_unit: tempStatus, bloodGlucose_status: tempGlucoseStatus, bloodGlucose_date: format.parse(tempGlucoseDate),bloodGlucose_time: timeformat.parse(tempGlucoseTime));
    //         bgtemp.add(bloodGlucose);
    //       }
    //       break;
    //     }
    //
    //   }
    //   for(var i=0;i<bgtemp.length/2;i++){
    //     var temp = bgtemp[i];
    //     bgtemp[i] = bgtemp[bgtemp.length-1-i];
    //     bgtemp[bgtemp.length-1-i] = temp;
    //   }
    // });
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text('Blood Glucose Level', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: add_blood_glucose(thislist: bgtemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      bgtemp = value;
                    }
                    print("BGTEMP LENGTH AFTER SETSTATE  =="  + bgtemp.length.toString() );
                  }));
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bgtemp.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 140,
                child: Stack(
                    children: [
                      Positioned (
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.7),
                                      Colors.white
                                    ]
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.grey.withOpacity(0.6),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ]
                            )
                        ),
                      ),
                      Positioned(
                        top: 25,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [

                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                  '' + getDateFormatted(bgtemp[index].bloodGlucose_date.toString())+getTimeFormatted(bgtemp[index].bloodGlucose_time.toString())+" \n"
                                      +"Status: "+bgtemp[index].bloodGlucose_status+
                                      "\nBlood Glucose: " + bgtemp[index].glucose.toString() + " mg/dL",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                )
            ),
          );
        },
      ),

    );
  }
  String getDateFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    if(date != null){
      var dateTime = DateTime.parse(date);
      var hours = dateTime.hour.toString().padLeft(2, "0");
      var min = dateTime.minute.toString().padLeft(2, "0");
      return "$hours:$min";
    }
  }
  void getBloodGlucose() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBC = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/');
    readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bgtemp.add(Blood_Glucose.fromJson(jsonString));
      });
    });
  }
}