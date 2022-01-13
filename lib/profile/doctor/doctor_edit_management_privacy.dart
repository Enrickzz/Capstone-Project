import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class doctor_edit_management_privacy extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  String userUID;
  doctor_edit_management_privacy({this.thislist, this.userUID});
  @override
  _editManagementPrivacyState createState() => _editManagementPrivacyState();
}
final _formKey = GlobalKey<FormState>();
class _editManagementPrivacyState extends State<doctor_edit_management_privacy> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  bool isAllowedMedicalPrescription = false;
  bool isAllowedFoodPlan = false;
  bool isAllowedExercisePlan = false;
  bool isAllowedVitalsRecording = false;
  bool showDisclaimer = false;








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
                    "Edit Management Plan Access",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 12.0),
                  Divider(),
                  SwitchListTile(
                    title: Text('Medical Prescription', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor to see My Prescribed Medications', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showMedicalPrescription();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedMedicalPrescription,
                    onChanged: (value){
                      setState(() {
                        isAllowedMedicalPrescription = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),


                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Food Plan', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor Systems to see My Prescribed Food Plans', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showFoodPlan();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedFoodPlan,
                    onChanged: (value){
                      setState(() {
                        isAllowedFoodPlan = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),

                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Exercise Plan', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor Systems to see My Prescribed Exercise Plans', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showExercise();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedExercisePlan,
                    onChanged: (value){
                      setState(() {
                        isAllowedExercisePlan = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),

                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Vitals Recording', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor Systems to see My Prescribed Vitals Recording', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showVitalsRecording();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedVitalsRecording,
                    onChanged: (value){
                      setState(() {
                        isAllowedVitalsRecording = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),

                  SizedBox(height: 16.0),
                  Visibility(
                    visible: showDisclaimer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Disclaimer: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                          ),

                        ),
                        SizedBox(height: 8.0),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Your designated management plan for the patient is considered important for other doctors to know about.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                          ),

                        ),

                      ],
                    ),
                  ),
                  Divider(),


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
                          'Change',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          _showMyDialog();

                        },

                        // Navigator.pop(context);

                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  Future<void> showMedicalPrescription() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Medical Prescriptions'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed medication for this patient.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),


              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showFoodPlan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Food Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed food plan for this patient.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showExercise() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exercise Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed exercise plan for this patient.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showVitalsRecording() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vitals Recording Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed vitals recording plan for this patient.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Change'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to change access to your management plan?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {

                // Future.delayed(const Duration(milliseconds: 2000), (){
                //   print(namestemp.length);
                //   print('^^^^^^^^^^^^^^^^^^^^^^^^^^^');
                //   Navigator.pushReplacement(context,
                //       MaterialPageRoute(builder: (context) => PatientList(nameslist: namestemp,diseaselist: diseasetemp, uidList: uidtemp,)));
                // });

              },
            ),
            TextButton(
              child: Text('Cancel'),
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