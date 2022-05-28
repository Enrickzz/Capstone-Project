import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/management_plan/lab_plan/specific_lab_plan_patient_view.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';


//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class lab_prescription_patient_view extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  final String userUID;
  lab_prescription_patient_view({Key key, this.preslist, this.pointer, this.userUID}): super(key: key);
  @override
  _lab_management_plan_patient_view_prescriptionState createState() => _lab_management_plan_patient_view_prescriptionState();
}

class _lab_management_plan_patient_view_prescriptionState extends State<lab_prescription_patient_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Lab_Plan> labplantemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  Users doctor = new Users();
  List<String> doctor_names = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    labplantemp.clear();
    getLabPlan();
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
          title: const Text('Requested Lab Results', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,

        ),
        body: ListView.builder(
            itemCount: labplantemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.document_scanner_outlined),
                    title: Text(labplantemp[index].type,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Requested by: Dr." + labplantemp[index].doctor_name,
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${labplantemp[index].dateCreated.month}/${labplantemp[index].dateCreated.day}/${labplantemp[index].dateCreated.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificLabRequestViewAsPatient(thislist: labplantemp, index: index)),
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
  void getLabPlan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    // String userUID = widget.userUID;
    final readFoodPlan = databaseReference.child('users/' + uid + '/management_plan/lab_plan/');
    readFoodPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        labplantemp.add(Lab_Plan.fromJson(jsonString));
      });
      labplantemp = labplantemp.reversed.toList();
    });
  }
}