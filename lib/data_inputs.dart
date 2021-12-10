import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/symptoms.dart';

import 'medication.dart';
import 'models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class data_inputs extends StatefulWidget {
  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<data_inputs> {
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
        title: const Text('Data Inputs', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                    List<Symptom> thislist = new List<Symptom>();
                    thislist.add(new Symptom(symptom_name: "1", intesity_lvl: 1, symptom_felt: "1",symptom_date: "1") );
                    thislist.add(new Symptom(symptom_name: "2", intesity_lvl: 2, symptom_felt: "2",symptom_date: "2") );
                    thislist.add(new Symptom(symptom_name: "3", intesity_lvl: 3, symptom_felt: "3",symptom_date: "3") );
                    thislist.add(new Symptom(symptom_name: "4", intesity_lvl: 4, symptom_felt: "4",symptom_date: "4") );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => symptoms(symptomlist1: thislist)),
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
                              child: Image.asset('assets/images/symptoms.jpg',
                              fit: BoxFit.cover
                              ),
                            ),
                          ),
                          Positioned (
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 120,
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
                                    Container(
                                      padding: EdgeInsets.all(5),
                                        child: Container(
                                            child: Image.asset('assets/images/symptoms2.jpg'),
                                          height:30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                          'Symptoms',
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
                      MaterialPageRoute(builder: (context) => medication()),
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
                                  height: 120,
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
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        child: Image.asset('assets/images/medication2.jpg'),
                                        height:30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            bottomRight: Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        'Medication Intake',
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
                      MaterialPageRoute(builder: (context) => medication()),
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
                                child: Image.asset('assets/images/labresults.jpg',
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                            Positioned (
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 120,
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
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        child: Image.asset('assets/images/labresults2.jpg'),
                                        height:30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            bottomRight: Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        'Laboratory Results',
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
                      MaterialPageRoute(builder: (context) => mainScreen()),
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
                                child: Image.asset('assets/images/vitals.jpg',
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                            Positioned (
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 120,
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
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        child: Image.asset('assets/images/vitals2.png'),
                                        height:30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            bottomRight: Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        'Vitals',
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
    );
  }
}
