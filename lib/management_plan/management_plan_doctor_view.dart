import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/data_inputs/vitals/body_temperature/body_temperature_patient_view.dart';
import 'package:my_app/data_inputs/vitals/oxygen_saturation/o2_saturation_patient_view.dart';
import 'package:my_app/data_inputs/vitals/respiratory_rate/respiratory_rate_patient_view.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../fitness_app_theme.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

import 'package:my_app/management_plan/food_plan/food_plan_doctor_view.dart';
import 'package:my_app/management_plan/exercise_plan/exercise_plan_doctor_view.dart';

import 'vitals_plan/vitals_plan_doctor_view.dart';

class management_plan extends StatefulWidget {
  String userUID;
  management_plan({this.userUID});
  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<management_plan> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Users usertype = new Users();


  List<Connection> connections = [];
  List<Connection> doctor_connections = [];
  ///for data privacy
  String canViewMedPres = "true";
  String canViewFoodPlan = "true";
  String canViewExPlan = "true";
  String canViewVitals = "true";

  @override
  void initState() {
    getPrivacy();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String patientUID = widget.userUID;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text("Patient's Management Plans", style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => medication_prescription(userUID: patientUID, connection_list: doctor_connections)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 140,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/medication.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Medication Prescription',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => food_prescription_doctor_view(userUID: patientUID)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 140,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/food.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Food Plan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => exercise_prescription_doctor_view(userUID: patientUID)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 140,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/exercise.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Exercise Plan',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => vitals_prescription_doctor_view(userUID: patientUID)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 140,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/vital_recording.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Vitals Recording',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getPrivacy () {
    final User user = auth.currentUser;
    final uid = user.uid;
    String userUID = widget.userUID;
    final readConnection = databaseReference.child('users/' + userUID + '/personal_info/connections/');
    readConnection.once().then((DataSnapshot snapshot){
      List<dynamic> temp1 = jsonDecode(jsonEncode(snapshot.value));
      print(temp1);
      temp1.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString));
      });
      for(int i = 0; i < connections.length; i++){
        final readUserType = databaseReference.child('users/'+ connections[i].uid + '/personal_info/');
        readUserType.once().then((DataSnapshot usersnapshot){
          Map<String, dynamic> temp2 = jsonDecode(jsonEncode(usersnapshot.value));
          usertype = Users.fromJson(temp2);
          if(usertype == "Doctor"){
            final readDocConnection = databaseReference.child('users/' + connections[i].uid + '/personal_info/connections/');
            readDocConnection.once().then((DataSnapshot datasnapshot){
              List<dynamic> temp3 = jsonDecode(jsonEncode(datasnapshot.value));
              if(temp3.contains(userUID)){
                temp3.forEach((jsonString) {
                  doctor_connections.add(Connection.fromJson2(jsonString));
                });
              }
            });
          }
        });
      }
    });
  }

}