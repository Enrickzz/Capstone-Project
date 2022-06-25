import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/medicine_intake/view_specific_medicine_patient_view.dart';
import 'package:my_app/distress_call_logs/patient%20or%20support_system/specific_call_log_as_support.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsSupport.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class call_log_suppView extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  final String userUID;
  call_log_suppView({Key key, this.preslist, this.pointer, this.userUID}): super(key: key);
  @override
  call_logSupportViewState createState() => call_logSupportViewState();
}

class call_logSupportViewState extends State<call_log_suppView> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<distressSOS> SOS = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    SOS.clear();
    getSOS();
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
          title: const Text('Distress Calls', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body:  ListView.builder(
            itemCount: SOS.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Image.asset(
                      'assets/images/emergency.png',
                      width: 32,
                      height: 32,
                    ),
                    title: Text(SOS[index].full_name +" ("+ SOS[index].number+")",
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle:        Text(""+SOS[index].rec_date,
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text(""+SOS[index].rec_time,
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: false,
                    dense: true,
                    selected: true,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificCallLogAsSupport(thislist: SOS, index: index,userUID: widget.userUID,)),
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
  void getSOS() {
    final User user = auth.currentUser;
    final uid = user.uid;
    String userUID = widget.userUID;
    var readsos;
    if(userUID != null){
      readsos = databaseReference.child('users/' + userUID + '/SOSCalls/');
    }else readsos = databaseReference.child('users/' + uid + '/SOSCalls/');
    readsos.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        SOS.add(distressSOS.fromJson(jsonString));
      });
      // SOS = SOS.reversed.toList();
    });
  }
}