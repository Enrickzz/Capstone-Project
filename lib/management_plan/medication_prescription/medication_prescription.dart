import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsDoctor.dart';
import 'add_medication_prescription.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class medication_prescription extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  medication_prescription({Key key, this.preslist, this.pointer}): super(key: key);
  @override
  _medication_prescriptionState createState() => _medication_prescriptionState();
}

class _medication_prescriptionState extends State<medication_prescription> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Medication_Prescription> prestemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    prestemp.clear();
    // final readPrescription = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list');
    // String tempGenericName = "";
    // String tempBrandedName = "";
    // String tempIntakeTime = "";
    // String tempSpecialInstruction = "";
    // String tempStartDate = "";
    // String tempEndDate = "";
    // String tempPrescriptionUnit = "";
    // readPrescription.once().then((DataSnapshot datasnapshot) {
    //
    //   String temp1 = datasnapshot.value.toString();
    //   List<String> temp = temp1.split(',');
    //   Medication_Prescription prescription;
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //       switch(i%7){
    //         case 0: {
    //           tempPrescriptionUnit = splitFull.last;
    //         }
    //         break;
    //         case 1: {
    //           tempEndDate = splitFull.last;
    //
    //         }
    //         break;
    //         case 2: {
    //           tempIntakeTime = splitFull.last;
    //         }
    //         break;
    //         case 3: {
    //           tempBrandedName = splitFull.last;
    //
    //         }
    //         break;
    //         case 4: {
    //           tempSpecialInstruction = splitFull.last;
    //         }
    //         break;
    //         case 5: {
    //           tempGenericName = splitFull.last;
    //         }
    //         break;
    //         case 6: {
    //           tempStartDate = splitFull.last;
    //           prescription = new Medication_Prescription(generic_name: tempGenericName, branded_name: tempBrandedName, startdate: format.parse(tempStartDate), enddate: format.parse(tempEndDate), intake_time: tempIntakeTime, special_instruction: tempSpecialInstruction, prescription_unit: tempPrescriptionUnit);
    //           prestemp.add(prescription);
    //         }
    //         break;
    //       }
    //
    //   }
    //   for(var i=0;i<prestemp.length/2;i++){
    //     var temp = prestemp[i];
    //     prestemp[i] = prestemp[prestemp.length-1-i];
    //     prestemp[prestemp.length-1-i] = temp;
    //   }
    // });
    getMedicalPrescription();
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
        title: const Text('Medication Prescription', style: TextStyle(
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
                      child: add_medication_prescription(thislist: prestemp),
                    ),
                    ),
                  ).then((value) =>
                      Future.delayed(const Duration(milliseconds: 1500), (){
                        setState((){
                          print("setstate medication prescription");
                          print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                          if(value != null){
                            prestemp = value[0];
                          }
                        });
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
            itemCount: prestemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.medication_outlined ),
                    title: Text("Brand Name: " + prestemp[index].branded_name ,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Prescribed by: Dr." ,
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("mm/dd/yyyy" ,
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,



                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificPrescriptionViewAsDoctor()),
                      );
                    }

                ),

              ),
            )
        )
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
  void getMedicalPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prestemp.add(Medication_Prescription.fromJson(jsonString));
      });
    });
  }
}