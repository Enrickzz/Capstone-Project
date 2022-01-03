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
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';

import 'add_medication.dart';
import '../../fitness_app_theme.dart';
import '../../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class medication extends StatefulWidget {
  final List<Medication> medlist;
  medication({Key key, this.medlist}): super(key: key);
  @override
  _medicationState createState() => _medicationState();
}

class _medicationState extends State<medication> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TimeOfDay time;
  List<Medication> medtemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list');
    String tempMedicineName = "";
    String tempMedicineType = "";
    String tempMedicineDate = "";
    double tempMedicineDosage = 0;
    String tempMedicineTime = "";
    medtemp.clear();
    getMedication();

    // readMedication.once().then((DataSnapshot datasnapshot) {
    //   medtemp.clear();
    //   String temp1 = datasnapshot.value.toString();
    //   print(temp1);
    //   List<String> temp = temp1.split(',');
    //   Medication medicine;
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //
    //       switch(i%5){
    //         case 0: {
    //           tempMedicineType = splitFull.last;
    //         }
    //         break;
    //         case 1: {
    //           tempMedicineDosage = double.parse(splitFull.last);
    //         }
    //         break;
    //         case 2: {
    //           tempMedicineDate = splitFull.last;
    //
    //         }
    //         break;
    //         case 3: {
    //           tempMedicineName = splitFull.last;
    //
    //         }
    //         break;
    //         case 4: {
    //           tempMedicineTime = splitFull.last;
    //           medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: format.parse(tempMedicineDate), medicine_time: timeformat.parse(tempMedicineTime));
    //           medtemp.add(medicine);
    //         }
    //         break;
    //       }
    //   }
    //   for(var i=0;i<medtemp.length/2;i++){
    //     var temp = medtemp[i];
    //     medtemp[i] = medtemp[medtemp.length-1-i];
    //     medtemp[medtemp.length-1-i] = temp;
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
        title: const Text('Medication Intake', style: TextStyle(
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
                      child: add_medication(thislist: medtemp),
                    ),
                    ),
                  ).then((value) =>
                    Future.delayed(const Duration(milliseconds: 1500), (){
                      setState((){
                        print("setstate medicines");
                        if(value != null){
                          medtemp = value;
                        }
                        print("medetmp.length == " +medtemp.length.toString());
                      });
                    }));

                },
                child: Icon(
                  Icons.add,
                )
              )
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: medtemp.length,
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
                                  '' + getDateFormatted(medtemp[index].medicine_date.toString()) + getTimeFormatted(medtemp[index].medicine_time.toString())+" "
                                      + "\nMedicine: " + medtemp[index].medicine_name + " "
                                      +"\nDosage "+ medtemp[index].medicine_dosage.toString()+ " "
                                      +"\nType: "+ medtemp[index].medicine_type,
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
  void getMedication() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readmedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/');
    readmedication.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        medtemp.add(Medication.fromJson(jsonString));
      });
    });
  }
}
