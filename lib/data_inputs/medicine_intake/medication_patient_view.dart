import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/medicine_intake/view_specific_medicine_patient_view.dart';

import 'add_medication.dart';
import '../../models/users.dart';
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
    medtemp.clear();
    getMedication();
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
                  ).then((value) {
                    if(value != null){
                      medtemp.insert(0, value);
                      setState((){
                      });
                    }

                  });
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
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              child: ListTile(
                  leading: Icon(Icons.medication_outlined ),
                  title: Text(medtemp[index].medicine_name ,
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,

                      )),
                  subtitle:        Text("${medtemp[index].medicine_time.hour.toString().padLeft(2, '0')}:${medtemp[index].medicine_time.minute.toString().padLeft(2, '0')}" ,
                      style:TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      )),
                  trailing: Text("${medtemp[index].medicine_date.month.toString().padLeft(2, '0')}/${medtemp[index].medicine_date.day.toString().padLeft(2, '0')}/${medtemp[index].medicine_date.year}",
                      style:TextStyle(
                        color: Colors.grey,
                      )),
                  isThreeLine: true,
                  dense: true,
                  selected: true,
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpecificMedicineIntakeViewAsPatient(index: index)),
                    ).then((value) {
                      if(value != null){
                        print("length b4 = " + medtemp.length.toString());
                        medtemp = value;
                        print("length af = " +medtemp.length.toString());
                        setState(() {
                          medtemp = value;
                        });
                      }
                    });
                  }

              ),

            ),
          )
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
      print("TEMP  ");
      print(temp);
      temp.forEach((jsonString) {
        medtemp.add(Medication.fromJson(jsonString));
      });
      for(var i=0;i<medtemp.length/2;i++){
        var temp = medtemp[i];
        medtemp[i] = medtemp[medtemp.length-1-i];
        medtemp[medtemp.length-1-i] = temp;
      }
    });
  }
}
