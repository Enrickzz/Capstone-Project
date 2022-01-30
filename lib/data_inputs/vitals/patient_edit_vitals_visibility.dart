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
class patient_edit_vitals_visibility extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  final Connection connection;
  patient_edit_vitals_visibility({this.thislist, this.connection});
  @override
  _editMedicationPrescriptionState createState() => _editMedicationPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _editMedicationPrescriptionState extends State<patient_edit_vitals_visibility> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  // List<Connection> connections = [];
  bool isBloodPressureVisible = false;
  bool isBloodGlucoseVisible = false;
  bool isHeartRateVisible = false;
  bool isRespiratoryRateVisible = false;
  bool isOxygenSaturationVisible = false;
  bool isBodyTemperatureVisible = false;


  @override
  void initState(){
    super.initState();
    // Connection doctorconnection = widget.connection;
    // if(doctorconnection.dashboard.toLowerCase() == "false"){
    //   isAllowedDashboard = false;
    // }
    // if(doctorconnection.nonhealth.toLowerCase() == "false"){
    //   isAllowedNonHealth = false;
    // }
    // if(doctorconnection.health.toLowerCase() == "false"){
    //   isAllowedDataInputs = false;
    // }
    // if(isAllowedDashboard == false || isAllowedNonHealth == false || isAllowedDataInputs == false){
    //   showDisclaimer = true;
    // }
    // Future.delayed(const Duration(milliseconds: 1000), (){
    //   setState(() {
    //   });
    // });
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
                    "Vitals Recording",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 12.0),
                  Divider(),
                  SwitchListTile(
                    title: Text('Blood Pressure', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('I want to record my Blood Pressure', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showDashboardInfo();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isBloodPressureVisible,
                    onChanged: (value){
                      setState(() {
                        isBloodPressureVisible = value;


                      });
                    },
                  ),


                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Heart Rate', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('I want to record my Heart Rate', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showNonHealthDataInfo();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isHeartRateVisible,
                    onChanged: (value){
                      setState(() {
                        isHeartRateVisible = value;


                      });
                    },
                  ),

                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Body Temperature', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('I want to record my Body Temperature', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showDataInputs();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isBodyTemperatureVisible,
                    onChanged: (value){
                      setState(() {
                        isBodyTemperatureVisible = value;



                      });
                    },
                  ),
                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Blood Glucose', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('I want to record my Blood Glucose', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showDataInputs();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isBloodGlucoseVisible,
                    onChanged: (value){
                      setState(() {
                        isBloodGlucoseVisible = value;



                      });
                    },
                  ),
                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Respiratory Rate', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('I want to record my Respiratory Rate', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showDataInputs();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isRespiratoryRateVisible,
                    onChanged: (value){
                      setState(() {
                        isRespiratoryRateVisible = value;



                      });
                    },
                  ),
                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Oxygen Saturation', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('I want to record my Oxygen Saturation', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showDataInputs();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isOxygenSaturationVisible,
                    onChanged: (value){
                      setState(() {
                        isOxygenSaturationVisible = value;



                      });
                    },
                  ),

                  // SizedBox(height: 16.0),
                  // Visibility(
                  //   visible: showDisclaimer,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     children: <Widget> [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 8.0),
                  //         child: Text(
                  //           "Disclaimer: ",
                  //           textAlign: TextAlign.left,
                  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                  //         ),
                  //
                  //       ),
                  //       SizedBox(height: 8.0),
                  //
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 8.0),
                  //         child: Text(
                  //           "All of these information are considered integral components that paint the whole picture of your health. Disallowing your Doctor/Support system to access one of these areas would lead them to have an incomplete view of your health.",
                  //           textAlign: TextAlign.justify,
                  //           style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  //         ),
                  //
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
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
                          Navigator.pop(context);
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
  Future<void> showDashboardInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Health Dashboards'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("Your Health Dashboards exist to help your Doctors and Support System better understand the various health records presented in different graphs to provide them a detailed view of different components of your health. \n\nThese Include:",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12.0,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 20,),
                    Text('Heart Rate Time Series')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20,),
                    Text('Blood Pressure Time Series')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(width: 20,),
                    Text('Cholesterol Level')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20,),
                    Text('Blood Glucose Level Chart')
                  ],
                )







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

  Future<void> showNonHealthDataInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Non-Health Data'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("Your Non-Health Data Information records are crucial aspects of your overall health picture. These information are available in the application to help your Doctors/Support system better keep track of your day-to-day Non-Health data related information. \n\nThese Include:",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12.0,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 20,),
                    Text('Daily Water Intake')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20,),
                    Text('Daily Food Consumption')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(width: 20,),
                    Text('Daily Exercises')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20,),
                    Text('Daily Sleep Information')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.greenAccent,
                    ),
                    SizedBox(width: 20,),
                    Text('Stress Information')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.pink,
                    ),
                    SizedBox(width: 20,),
                    Text('Weight Information')
                  ],
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
  Future<void> showDataInputs() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Health Data Inputs'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("Your Health Data Inputs are the various medical information you store in the application. These information are available in the application to help your Doctors/Support system better keep track of your health and see the progression of your health. \n\nThese Include:",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12.0,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 20,),
                    Text('Recorded Vitals')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20,),
                    Text('Supplements/Medicines')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(width: 20,),
                    Text('Medicine Intake')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20,),
                    Text('Record of Symptoms')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.greenAccent,
                    ),
                    SizedBox(width: 20,),
                    Text('Laboratory Results')
                  ],
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

                Text('Are you sure you want to change his/her data access?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                // try{
                //   final User user = auth.currentUser;
                //   final uid = user.uid;
                //   final readPatientConnection = databaseReference.child('users/' + uid + '/personal_info/connections/');
                //   Connection doctorconnection = widget.connection;
                //   readPatientConnection.once().then((DataSnapshot snapshot) {
                //     List<dynamic> temp1 = jsonDecode(jsonEncode(snapshot.value));
                //     temp1.forEach((jsonString) {
                //       connections.add(Connection.fromJson(jsonString));
                //     });
                //     for(int i = 1; i <= connections.length; i++){
                //       if(connections[i-1].uid == doctorconnection.uid){
                //         final doctorConnectionsRef = databaseReference.child('users/' + uid + '/personal_info/connections/'+ i.toString());
                //         doctorConnectionsRef.update({
                //           "uid": doctorconnection.uid,
                //           "dashboard": isAllowedDashboard.toString(),
                //           "nonhealth": isAllowedNonHealth.toString(),
                //           "health": isAllowedDataInputs.toString(),
                //         });
                //       }
                //     }
                //   });
                //   Navigator.pop(context);
                //
                //
                // } catch(e) {
                //   print("you got an error! $e");
                // }


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