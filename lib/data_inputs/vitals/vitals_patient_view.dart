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
import 'package:my_app/data_inputs/vitals/patient_edit_vitals_visibility.dart';
import 'package:my_app/data_inputs/vitals/respiratory_rate/respiratory_rate_patient_view.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/profile/patient/patient_view_support_system.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';

import '../../fitness_app_theme.dart';
import 'blood_cholesterol/blood_cholesterol.dart';
import 'blood_glucose/blood_glucose_patient_view.dart';
import 'blood_pressure/blood_pressure_patient_view.dart';
import 'heart_rate/heart_rate_patient_view.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class vitals extends StatefulWidget {

  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<vitals> {
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
  List<Blood_Pressure> thisbplist = new List<Blood_Pressure>();
  List<Heart_Rate> thisHRlist = new List<Heart_Rate>();
  List<Body_Temperature> thisBTlist = new List<Body_Temperature>();
  List<Oxygen_Saturation> o2List = new List<Oxygen_Saturation>();
  List<Blood_Cholesterol> bclist = new List<Blood_Cholesterol>();
  List<Blood_Glucose> bglist = new List<Blood_Glucose>();
  List<Respiratory_Rate> rlist = new List<Respiratory_Rate>();

  //vitals visibility
  bool isBloodPressureVisible = false;
  bool isHeartRateVisible = false;
  bool isBodyTemperatureVisible = false;
  bool isBloodGlucoseVisible = false;
  bool isRespiratoryRateVisible = false;
  bool isOxygenSaturationVisible = false;

  @override
  void initState(){
    super.initState();
    getVitalsConnection();
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
      });
    });
  }

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
        title: const Text('Recorded Vitals', style: TextStyle(
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
                      child: patient_edit_vitals_visibility(),
                    ),
                    ),
                  ).then((value) =>
                      Future.delayed(const Duration(milliseconds: 1500), (){
                        setState((){
                          print("setstate medication prescription");
                          print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                          if(value != null){
                            // templist = value[0];
                          }
                        });
                      }));


                },
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                ),
              )
          ),
        ],
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
                  Visibility(
                    visible: isBloodPressureVisible,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => blood_pressure(bplist: thisbplist)),
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
                                    child: Image.asset('assets/images/bloodpressure.jpg',
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
                                            'Blood Pressure',
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
                  ),
                  Visibility(
                    visible: isHeartRateVisible,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => heart_rate(hrlist: thisHRlist)),
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
                                    child: Image.asset('assets/images/heartrate.jpg',
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
                                            'Heart Rate',
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
                  ),
                  Visibility(
                    visible: isBodyTemperatureVisible,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => body_temperature(btlist: thisBTlist)),
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
                                    child: Image.asset('assets/images/bodytemperature.jpg',
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
                                            'Body Temperature',
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
                  ),
                  Visibility(
                    visible: isBloodGlucoseVisible,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => blood_glucose(bglist: bglist)),
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
                                    child: Image.asset('assets/images/bloodglucose.jpg',
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
                                            'Blood Glucose Level',
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
                  ),
                  Visibility(
                    visible: isRespiratoryRateVisible,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => respiratory_rate(rList: rlist)),
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
                                    child: Image.asset('assets/images/respiratoryrate.jpg',
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
                                            'Respiratory Rate',
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
                  ),
                  Visibility(
                    visible: isOxygenSaturationVisible,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => o2_saturation(oxygenlist: o2List)),
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
                                    child: Image.asset('assets/images/o2saturation.jpg',
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
                                            'Oxygen Saturation',
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
                  ),
                  // GestureDetector(
                  //   onTap:(){
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => blood_cholesterol(bclist: bclist)),
                  //     );
                  //   },
                  //   child: Container(
                  //       margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  //       height: 100,
                  //       child: Stack(
                  //           children: [
                  //             Positioned.fill(
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(20),
                  //                 child: Image.asset('assets/images/bloodcholesterol.jpg',
                  //                     fit: BoxFit.cover
                  //                 ),
                  //               ),
                  //             ),
                  //             Positioned (
                  //               bottom: 0,
                  //               left: 0,
                  //               right: 0,
                  //               child: Container(
                  //                   height: 80,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.only(
                  //                           bottomLeft: Radius.circular(20),
                  //                           bottomRight: Radius.circular(20)
                  //                       ),
                  //                       gradient: LinearGradient(
                  //                           begin: Alignment.bottomCenter,
                  //                           end: Alignment.topCenter,
                  //                           colors: [
                  //                             Colors.black.withOpacity(0.7),
                  //                             Colors.transparent
                  //                           ]
                  //                       )
                  //                   )
                  //               ),
                  //             ),
                  //             Positioned(
                  //               bottom: 0,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(10),
                  //                 child: Row(
                  //                   children: [
                  //                     SizedBox(
                  //                       width: 10,
                  //                     ),
                  //                     Text(
                  //                         'Blood Cholesterol Level',
                  //                         style: TextStyle(
                  //                             color: Colors.white,
                  //                             fontSize: 18
                  //                         )
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ]
                  //       )
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getVitalsConnection (){
    final User user = auth.currentUser;
    final uid = user.uid;
    final vitalsConnectionRef = databaseReference.child('users/' + uid + '/vitals_connection/');
    Vitals_Connection vitals_connection;
    vitalsConnectionRef.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      vitals_connection = Vitals_Connection.fromJson(temp);
      if(vitals_connection.bloodpressure == "true"){
        isBloodPressureVisible = true;
      }
      if(vitals_connection.bloodglucose == "true"){
        isBloodGlucoseVisible = true;
      }
      if(vitals_connection.heartrate == "true"){
        isHeartRateVisible = true;
      }
      if(vitals_connection.respiratoryrate == "true"){
        isRespiratoryRateVisible = true;
      }
      if(vitals_connection.oxygensaturation == "true"){
        isOxygenSaturationVisible = true;
      }
      if(vitals_connection.bodytemperature == "true"){
        isBodyTemperatureVisible = true;
      }
    });
  }
}