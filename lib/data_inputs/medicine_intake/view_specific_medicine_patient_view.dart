import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/medicine_intake/edit_medication.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/users.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificMedicineIntakeViewAsPatient(),
    );
  }
}

class SpecificMedicineIntakeViewAsPatient extends StatefulWidget {
  SpecificMedicineIntakeViewAsPatient({Key key, this.index}) : super(key: key);
  // final String title;
  // String userUID;
  int index;
  @override
  _SpecificSupplementViewAsPatientState createState() => _SpecificSupplementViewAsPatientState();
}

class _SpecificSupplementViewAsPatientState extends State<SpecificMedicineIntakeViewAsPatient> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Medication> listtemp = [];
  // Medication medication = new Medication();
  String medicine_name = "";
  String medicine_dosage = "";
  String medicine_type = "";
  String medicine_date = "";
  String medicine_time = "";
  String medicine_unit ="";

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    getMedication();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    int initLeng = listtemp.length;
                    _showMyDialogDelete().then((value) {
                      if(initLeng != listtemp.length){
                        Navigator.pop(context, value);
                      }
                    });
                  },
                  child: Icon(
                    Icons.delete,
                  ),
                )
            ),
          ],
        ),
        body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, listtemp);
              return true;
            },
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget>[
                              Expanded(
                                child: Text( medicine_name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:Color(0xFF4A6572),
                                    )
                                ),
                              ),
                              InkWell(
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    showModalBottomSheet(context: context,
                                      isScrollControlled: true,
                                      builder: (context) => SingleChildScrollView(child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: edit_medication(index: widget.index, thislist: listtemp),
                                      ),
                                      ),
                                    ).then((value) =>
                                        Future.delayed(const Duration(milliseconds: 1500), (){
                                          setState((){
                                            if(value != null){
                                              Medication updated = value;
                                              medicine_name = updated.medicine_name;
                                              medicine_dosage = updated.medicine_dosage.toString();
                                              medicine_type = updated.medicine_type;
                                              medicine_date = DateFormat('MM/dd/yyyy').format(updated.medicine_date);
                                              medicine_time = DateFormat('hh:mm').format(updated.medicine_time);
                                              medicine_unit =updated.medicine_unit;

                                              listtemp[widget.index].medicine_name = updated.medicine_name;
                                              listtemp[widget.index].medicine_dosage = updated.medicine_dosage;
                                              listtemp[widget.index].medicine_type = updated.medicine_type;
                                              listtemp[widget.index]. medicine_date = updated.medicine_date;
                                              listtemp[widget.index].medicine_time = updated.medicine_time;
                                              listtemp[widget.index].medicine_unit =updated.medicine_unit;
                                              // Navigator.pop(context, listtemp );
                                            }
                                          });
                                        }));
                                  },
                                  // child: Padding(
                                  // padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Text( "Edit",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color:Color(0xFF2633C5),

                                          )
                                      ),
                                    ],
                                  )
                                // )
                              )

                            ]
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 200,
                          // height: 500, if may contact number and email
                          // margin: EdgeInsets.only(bottom: 50),
                          child: Stack(
                              children: [
                                Positioned(
                                    child: Material(
                                      child: Center(
                                        child: Container(
                                            width: 340,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    blurRadius: 20.0)],
                                            )
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Dosage",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text( medicine_dosage  + medicine_unit,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Text("Time Taken",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(medicine_time,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),


                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Text("Date Taken",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(medicine_date,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ]


                                        ),
                                      ),
                                    ))
                              ]
                          )
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),

    );


  }

  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                final User user = auth.currentUser;
                final uid = user.uid;
                int initialLength = listtemp.length;
                listtemp.removeAt(widget.index);
                /// delete fields
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < listtemp.length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/' + (i+1).toString());
                  bpRef.set({
                    "medicine_name": listtemp[i].medicine_name.toString(),
                    "medicine_type": listtemp[i].medicine_type.toString(),
                    "medicine_unit": listtemp[i].medicine_unit.toString(),
                    "medicine_dosage": listtemp[i].medicine_dosage.toString(),
                    "medicine_date": "${listtemp[i].medicine_date.month.toString().padLeft(2,"0")}/${listtemp[i].medicine_date.day.toString().padLeft(2,"0")}/${listtemp[i].medicine_date.year}",
                    "medicine_time": "${listtemp[i].medicine_time.hour.toString().padLeft(2,"0")}:${listtemp[i].medicine_time.minute.toString().padLeft(2,"0")}",
                  });
                }
                Navigator.pop(context, listtemp);

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


// Widget buildCopy() => Row(children: [
//   TextField(controller: controller),
//   IconButton(
//       icon: Icon(Icons.content_copy),
//       onPressed: (){
//         FlutterClipboard.copy(text);
//       },
//   )
//
// ],)
  void getMedication() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readmedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/');
    int index = widget.index;
    readmedication.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print(temp);
      temp.forEach((jsonString) {
        listtemp.add(Medication.fromJson(jsonString));
      });
      for(var i=0;i<listtemp.length/2;i++){
        var temp = listtemp[i];
        listtemp[i] = listtemp[listtemp.length-1-i];
        listtemp[listtemp.length-1-i] = temp;
      }
      medicine_name = listtemp[index].medicine_name;
      medicine_unit = listtemp[index].medicine_unit;
      medicine_dosage = listtemp[index].medicine_dosage.toString();
      medicine_type = listtemp[index].medicine_type;
      medicine_date = "${listtemp[index].medicine_date.month.toString().padLeft(2,"0")}/${listtemp[index].medicine_date.day.toString().padLeft(2,"0")}/${listtemp[index].medicine_date.year}";
      medicine_time = "${listtemp[index].medicine_time.hour.toString().padLeft(2,"0")}:${listtemp[index].medicine_time.minute.toString().padLeft(2,"0")}";
    });
  }
}

