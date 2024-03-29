import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/medicine_intake/view_specific_medicine_doctor_view.dart';
import '../../models/users.dart';
class medication_intake_doctor_view extends StatefulWidget {
  final List<Medication> medlist;
  String userUID;
  medication_intake_doctor_view({Key key, this.medlist, this.userUID}): super(key: key);
  @override
  _medicationState createState() => _medicationState();
}

class _medicationState extends State<medication_intake_doctor_view> {
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
                  subtitle:        Text("${medtemp[index].medicine_time.hour.toString().padLeft(2,"0")}:${medtemp[index].medicine_time.minute.toString().padLeft(2,"0")}" ,
                      style:TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      )),
                  trailing: Text("${medtemp[index].medicine_date.month}/${medtemp[index].medicine_date.day}/${medtemp[index].medicine_date.year}",
                      style:TextStyle(
                        color: Colors.grey,
                      )),
                  isThreeLine: true,
                  dense: true,
                  selected: true,
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpecificMedicineIntakeViewAsDoctor(userUID: widget.userUID, index: index)),
                    );
                  }

              ),

            ),
          )
      ),
      // body: ListView.builder(
      //   itemCount: medtemp.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       child: Container(
      //           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //           height: 140,
      //           child: Stack(
      //               children: [
      //                 Positioned (
      //                   bottom: 0,
      //                   left: 0,
      //                   right: 0,
      //                   child: Container(
      //                       height: 120,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.only(
      //                               bottomLeft: Radius.circular(20),
      //                               topLeft: Radius.circular(20),
      //                               topRight: Radius.circular(20),
      //                               bottomRight: Radius.circular(20)
      //                           ),
      //                           gradient: LinearGradient(
      //                               begin: Alignment.bottomCenter,
      //                               end: Alignment.topCenter,
      //                               colors: [
      //                                 Colors.white.withOpacity(0.7),
      //                                 Colors.white
      //                               ]
      //                           ),
      //                           boxShadow: <BoxShadow>[
      //                             BoxShadow(
      //                                 color: FitnessAppTheme.grey.withOpacity(0.6),
      //                                 offset: Offset(1.1, 1.1),
      //                                 blurRadius: 10.0),
      //                           ]
      //                       )
      //                   ),
      //                 ),
      //                 Positioned(
      //                   top: 25,
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(10),
      //                     child: Row(
      //                       children: [
      //                         SizedBox(
      //                           width: 10,
      //                         ),
      //                         Text(
      //                             '' + getDateFormatted(medtemp[index].medicine_date.toString()) + getTimeFormatted(medtemp[index].medicine_time.toString())+" "
      //                                 + "\nMedicine: " + medtemp[index].medicine_name + " "
      //                                 +"\nDosage "+ medtemp[index].medicine_dosage.toString()+ " "
      //                                 +"\nType: "+ medtemp[index].medicine_type,
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontSize: 18
      //                             )
      //                         ),
      //
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ]
      //           )
      //       ),
      //     );
      //   },
      // ),


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
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readmedication = databaseReference.child('users/' + userUID + '/vitals/health_records/medications_list/');
    readmedication.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        medtemp.add(Medication.fromJson(jsonString));
      });
    });
  }
}
