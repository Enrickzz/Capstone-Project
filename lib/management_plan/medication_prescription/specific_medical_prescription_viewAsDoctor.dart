import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../../dialogs/policy_dialog.dart';
import '../../fitness_app_theme.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/edit_medication_prescription.dart';






class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificPrescriptionViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificPrescriptionViewAsDoctor extends StatefulWidget {
  SpecificPrescriptionViewAsDoctor({Key key, this.title, this.userUID, this.index, this.thispres}) : super(key: key);
  final String title;
  final List<Medication_Prescription> thispres;
  String userUID;
  int index;
  @override
  _SpecificPrescriptionViewAsDoctorState createState() => _SpecificPrescriptionViewAsDoctorState();
}

class _SpecificPrescriptionViewAsDoctorState extends State<SpecificPrescriptionViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Medication_Prescription> prestemp = [];
  Medication_Prescription prescription = new Medication_Prescription();
  Users doctor = new Users();
  String generic_name = "";
  String dosage = "";
  String unit = "";
  String frequency = "";
  String special_instruction = "";
  String startDate = "";
  String endDate = "";
  String prescribedBy = "";
  String dateCreated = "";
  String brand_name ="";
  bool prescribedDoctor = false;
  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;

  //prescription image change this later
  Symptom thisSymptom;


  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    // getPrescription();
    final User user = auth.currentUser;
    final uid = user.uid;
    prestemp = widget.thispres;
    int index = widget.index;
    brand_name = prestemp[index].branded_name;
    generic_name = prestemp[index].generic_name;
    dosage = prestemp[index].dosage.toString();
    unit = prestemp[index].prescription_unit.toString();
    frequency = prestemp[index].intake_time;
    special_instruction = prestemp[index].special_instruction;
    startDate = "${prestemp[index].startdate.month}/${prestemp[index].startdate.day}/${prestemp[index].startdate.year}";
    endDate = "${prestemp[index].enddate.month}/${prestemp[index].enddate.day}/${prestemp[index].enddate.year}";
    dateCreated = "${prestemp[index].datecreated.month}/${prestemp[index].datecreated.day}/${prestemp[index].datecreated.year}";
    prescribedBy = prestemp[index].doctor_name;
    if(prestemp[index].prescribedBy == uid){
      prescribedDoctor = true;
    }
    // getPrescibedBy();
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
          title: Text('Prescription'),
          actions: [
            Visibility(
              visible: prescribedDoctor,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      int initLeng = prestemp.length;
                      _showMyDialogDelete().then((value) {
                        if(initLeng != prestemp.length){
                          Navigator.pop(context, value);
                        }
                      });
                    },
                    child: Icon(
                      Icons.delete,
                    ),
                  )
              ),
            ),
          ],

        ),
        body:  WillPopScope(
          onWillPop:()async{
            Navigator.pop(context,prestemp);
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
                      Visibility(
                        visible: prescribedDoctor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Expanded(
                                  child: Text( "Prescribed Medicine",
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
                                          child: edit_medication_prescription(thislist: prestemp, index: widget.index, userID: widget.userUID),
                                        ),
                                        ),
                                      ).then((value) =>
                                          Future.delayed(const Duration(milliseconds: 1500), (){
                                            setState((){
                                              if(value != null){
                                                print(value.toString());
                                                Medication_Prescription newMP = value;
                                                generic_name = newMP.generic_name;
                                                dosage = newMP.dosage.toString();
                                                unit = newMP.prescription_unit.toString();
                                                frequency = newMP.intake_time;
                                                special_instruction = newMP.special_instruction;
                                                startDate = newMP.startdate.toString();
                                                endDate = newMP.enddate.toString();
                                                prescribedBy = doctor.lastname;
                                                dateCreated = newMP.datecreated.toString();
                                                brand_name =newMP.branded_name;
                                                startDate = "${newMP.startdate.month}/${newMP.startdate.day}/${newMP.startdate.year}";
                                                endDate = "${newMP.enddate.month}/${newMP.enddate.day}/${newMP.enddate.year}";
                                                dateCreated = "${newMP.datecreated.month}/${newMP.datecreated.day}/${newMP.datecreated.year}";

                                                prestemp[widget.index].generic_name = newMP.generic_name;
                                                prestemp[widget.index].dosage = newMP.dosage;
                                                prestemp[widget.index].prescription_unit = newMP.prescription_unit.toString();
                                                prestemp[widget.index].intake_time = newMP.intake_time;
                                                prestemp[widget.index].special_instruction = newMP.special_instruction;
                                                prestemp[widget.index].startdate = newMP.startdate;
                                                prestemp[widget.index].enddate = newMP.enddate;
                                                prestemp[widget.index].prescribedBy = doctor.lastname;
                                                prestemp[widget.index].datecreated = newMP.datecreated;
                                                prestemp[widget.index].branded_name =newMP.branded_name;
                                                setState(() {

                                                });
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
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 400,
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
                                              Text("Brand Name",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(brand_name,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Generic Name",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(generic_name,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
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
                                              Text(dosage + " " + unit,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text("How many times a day?",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(frequency,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text("Special Instructions",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(special_instruction,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text("Date Period",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(startDate + ' - ' + endDate,
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
                      Visibility(
                        visible: hasImage,
                        child: InteractiveViewer(
                          clipBehavior: Clip.none,
                          minScale: minScale,
                          maxScale: maxScale,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: showimg(thisSymptom.imgRef),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 150,
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
                                              Text("Prescribed by",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Dr. " + prescribedBy,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Text("Date Prescribed",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(dateCreated,
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
        )
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
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return Image.asset("assets/images/no-image.jpg");
    }else{
      return Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
      (loadingProgress == null) ? child : CircularProgressIndicator());
    }
  }
  void getPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    final readprescription = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/');
    int index = widget.index;
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prestemp.add(Medication_Prescription.fromJson(jsonString));
      });
      for(var i=0;i<prestemp.length/2;i++){
        var temp = prestemp[i];
        prestemp[i] = prestemp[prestemp.length-1-i];
        prestemp[prestemp.length-1-i] = temp;
      }
      final readDoctorName = databaseReference.child('users/' + prestemp[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      if(prestemp[index].prescribedBy == uid){
        prescribedDoctor = true;
      }

      brand_name = prestemp[index].branded_name;
      generic_name = prestemp[index].generic_name;
      dosage = prestemp[index].dosage.toString();
      unit = prestemp[index].prescription_unit.toString();
      frequency = prestemp[index].intake_time;
      special_instruction = prestemp[index].special_instruction;
      startDate = "${prestemp[index].startdate.month}/${prestemp[index].startdate.day}/${prestemp[index].startdate.year}";
      endDate = "${prestemp[index].enddate.month}/${prestemp[index].enddate.day}/${prestemp[index].enddate.year}";
      dateCreated = "${prestemp[index].datecreated.month}/${prestemp[index].datecreated.day}/${prestemp[index].datecreated.year}";
    });
  }
  void getPrescibedBy(){
    int index = widget.index;
    final readDoctorName = databaseReference.child('users/' + prestemp[index].prescribedBy + '/personal_info/');
    readDoctorName.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
      doctor = Users.fromJson(temp2);
      prescribedBy = doctor.firstname + " " + doctor.lastname;
    });
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
                int initial_length = prestemp.length;
                prestemp.removeAt(widget.index);
                // List<int> delete_list = [];
                // for(int i = 0; i < listtemp.length; i++){
                //   if(_selected[i]){
                //     delete_list.add(i);
                //   }
                // }
                // delete_list.sort((a,b) => b.compareTo(a));
                // for(int i = 0; i < delete_list.length; i++){
                //   listtemp.removeAt(delete_list[i]);
                // }
                /// delete fields
                for(int i = 1; i <= initial_length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < prestemp.length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/' + (i+1).toString());
                  bpRef.set({
                    "generic_name": prestemp[i].generic_name.toString(),
                    "branded_name": prestemp[i].branded_name.toString(),
                    "dosage": prestemp[i].dosage.toString(),
                    "startDate": "${prestemp[i].startdate.month.toString().padLeft(2,"0")}/${prestemp[i].startdate.day.toString().padLeft(2,"0")}/${prestemp[i].startdate.year}",
                    "endDate": "${prestemp[i].enddate.month.toString().padLeft(2,"0")}/${prestemp[i].enddate.day.toString().padLeft(2,"0")}/${prestemp[i].enddate.year}",
                    "intake_time": prestemp[i].intake_time.toString(),
                    "special_instruction": prestemp[i].special_instruction.toString(),
                    "medical_prescription_unit": prestemp[i].prescription_unit.toString(),
                    "prescribedBy": prestemp[i].prescribedBy.toString(),
                    "datecreated": "${prestemp[i].datecreated.month.toString().padLeft(2,"0")}/${prestemp[i].datecreated.day.toString().padLeft(2,"0")}/${prestemp[i].datecreated.year}",
                  });
                }
                Navigator.pop(context, prestemp);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

