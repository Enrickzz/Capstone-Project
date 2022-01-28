import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsDoctor.dart';
import '../../fitness_app_theme.dart';
import '../../data_inputs/medicine_intake/add_medication.dart';
import 'add_medication_prescription.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class medication_prescription extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  final List<Connection> connection_list;
  String userUID;
  medication_prescription({Key key, this.preslist, this.pointer, this.userUID, this.connection_list}): super(key: key);
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
  int count = 1;
  Users doctor = new Users();
  List<String> doctor_names = [];
  List<Connection> connection_list = [];

  @override
  void initState() {
    super.initState();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    connection_list.clear();
    prestemp.clear();
    connection_list = widget.connection_list;
    getMedicalPrescription(connection_list);
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
                      child: add_medication_prescription(thislist: prestemp, userUID: widget.userUID),
                    ),
                    ),
                  ).then((value) {
                    if(value != null){
                      Medication_Prescription newP = value;
                      prestemp.insert(0, newP);
                      doctor_names.insert(0, doctor.lastname);
                      setState(() {

                      });
                    }
                  });
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
                    subtitle:        Text("Prescribed by: Dr." + checkthisDoc(doctor_names[index]),
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${prestemp[index].datecreated.month}/${prestemp[index].datecreated.day}/${prestemp[index].datecreated.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificPrescriptionViewAsDoctor(thispres: prestemp[index],userUID: widget.userUID, index: index)),
                      ).then((value) {
                        if(value != null){
                          print("length b4 = " + prestemp.length.toString());
                          prestemp = value;
                          print("length af = " +prestemp.length.toString());
                          setState(() {
                            prestemp = value;
                          });
                        }
                      });
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
  void getMedicalPrescription(List<Connection> connections) {
    final User user = auth.currentUser;
    final uid = user.uid;
    List<int> delete_list = [];
    var userUID = widget.userUID;
    final readprescription = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prestemp.add(Medication_Prescription.fromJson(jsonString));
      });
      for(int i = 0; i < prestemp.length; i++){
        print("CONNECTION LIST");
        print(connection_list.length);
        if(prestemp[i].prescribedBy != uid){
          for(int j = 0; j < connection_list.length; j++){
            if(prestemp[i].prescribedBy == connection_list[j].createdBy){
              if(connection_list[j].medpres != "true"){
                /// dont add
                delete_list.add(i);
              }
              else{
                /// add
              }
            }
          }
        }
        final readDoctor = databaseReference.child('users/' + prestemp[i].prescribedBy + '/personal_info/');
        readDoctor.once().then((DataSnapshot snapshot){
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          if(temp != null){
            doctor = Users.fromJson(temp);
            doctor_names.add(doctor.lastname);
            print("lastname doctor " + doctor.lastname);
            print("length " + doctor_names.length.toString());
          }
        });
      }
      delete_list.sort((a, b) => b.compareTo(a));
      for(int i = 0; i < delete_list.length; i++){
        prestemp.removeAt(delete_list[i]);
      }
      for(var i=0;i<prestemp.length/2;i++){
        var temp = prestemp[i];
        prestemp[i] = prestemp[prestemp.length-1-i];
        prestemp[prestemp.length-1-i] = temp;
      }
    });
  }
}
String checkthisDoc(String name) {
  if(name == null){
    return "";
  }else{
    return name;
  }
}