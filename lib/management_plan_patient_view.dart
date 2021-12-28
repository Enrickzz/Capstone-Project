import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/data_inputs/vitals/body_temperature.dart';
import 'package:my_app/data_inputs/vitals/o2_saturation.dart';
import 'package:my_app/data_inputs/vitals/respiratory_rate.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms.dart';

import '../fitness_app_theme.dart';
import 'package:my_app/data_inputs/medication_prescription.dart';
import 'package:my_app/view_medical_prescription_as_patient.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
import 'package:my_app/management_plan/food_plan/food_plan_patient_view.dart';

import 'management_plan/exercise_plan/exercise_plan_patient_view.dart';
import 'management_plan/vitals_plan/vitals_plan_patient_view.dart';
class management_plan_patient_view extends StatefulWidget {

  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<management_plan_patient_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';

  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text("My Management Plans", style: TextStyle(
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
                        MaterialPageRoute(builder: (context) => medication_prescription_patientView()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 100,
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
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'My Medication Prescription',
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
                        MaterialPageRoute(builder: (context) => food_prescription_patient_view()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 100,
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
                                          'My Food Plan',
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
                        MaterialPageRoute(builder: (context) => exercise_prescription_patient_view()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 100,
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
                    // onTap:(){
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => blood_glucose(bglist: bglist)),
                    //   );
                    // },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 100,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/activity.png',
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
                                          'Activities',
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
                        MaterialPageRoute(builder: (context) => vitals_prescription_patient_view()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 100,
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
}