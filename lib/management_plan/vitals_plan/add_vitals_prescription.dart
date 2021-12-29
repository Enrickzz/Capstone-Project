import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/management_plan/medication_prescription/medication_prescription.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/medication_prescription.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_vitals_prescription extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  add_vitals_prescription({this.thislist});
  @override
  _addVitalsrescriptionState createState() => _addVitalsrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addVitalsrescriptionState extends State<add_vitals_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateTime prescriptionDate;
  bool isDateSelected= false;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  String generic_name = "";
  String branded_name = "";
  String startdate = "";
  String enddate = "";
  double dosage = 0;
  String intake_time = "";
  String special_instruction = "";
  String prescription_unit = "mL";
  int count = 0;
  List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  String valueChooseInterval;
  List<String> listItemSymptoms = <String>[
    '1', '2', '3','4'
  ];
  double _currentSliderValue = 1;
  List <bool> isSelected = [true, false, false, false, false];
  int quantity = 1;

  DateTimeRange dateRange;

  // added by borj
  List<String> listVitals = <String>[
    'Blood Pressure', 'Blood Glucose','Oxygen Saturation', 'Body Temperature'
    ,'Heart Rate', 'Respiratory Rate'

  ];
  String valueChooseVital;


  String getFrom(){
    if(dateRange == null){
      return 'From';
    }
    else{
      return DateFormat('MM/dd/yyyy').format(dateRange.start);

    }
  }

  String getUntil(){
    if(dateRange == null){
      return 'Until';
    }
    else{
      return DateFormat('MM/dd/yyyy').format(dateRange.end);

    }
  }

  Future pickDateRange(BuildContext context) async{
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours:24 * 3)),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if(newDateRange == null) return;

    setState(() => {
      dateRange = newDateRange,
      startdate = "${dateRange.start.month}/${dateRange.start.day}/${dateRange.start.year}",
      enddate = "${dateRange.end.month}/${dateRange.end.day}/${dateRange.end.year}",

    });
    print("date Range " + dateRange.toString());
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
                    'Add Vitals Recording Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Purpose",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Generic Name' : null,
                    onChanged: (val){
                      setState(() => generic_name = val);
                    },
                  ),

                  SizedBox(height: 8.0),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Which Vital:",
                    ),
                    isExpanded: true,
                    value: valueChooseVital,
                    onChanged: (newValue){
                      setState(() {

                      });

                    },
                    items: listVitals.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Record how many times a day?",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("1"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("2"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("3"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("4"),
                            ],
                          ),
                          SizedBox(width: 3)
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 8.0),

                  TextFormField(
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Important Notes/Assessments",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Special Instructions' : null,
                    onChanged: (val){
                      setState(() => special_instruction = val);
                    },
                  ),
                  SizedBox(height: 24.0),
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
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readPrescription = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list');
                            readPrescription.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Medication_Prescription prescription;
                              if(datasnapshot.value == null){
                                final prescriptionRef = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list/' + 0.toString());
                                prescriptionRef.set({"generic_name": generic_name.toString(), "branded_name": branded_name.toString(),"dosage": dosage.toString(), "startDate": startdate.toString(), "endDate": enddate.toString(), "intake_time": quantity.toString(), "special_instruction": special_instruction, "medical_prescription_unit": prescription_unit, "prescribedBy": uid});
                                print("Added Medication Prescription Successfully! " + uid);
                              }
                              else{
                                // String tempGenericName = "";
                                // String tempBrandedName = "";
                                // String tempIntakeTime = "";
                                // String tempSpecialInstruction = "";
                                // String tempStartDate = "";
                                // String tempEndDate = "";
                                // String tempPrescriptionUnit = "";
                                // for(var i = 0; i < temp.length; i++){
                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                //   List<String> splitFull = full.split(" ");
                                //   switch(i%7){
                                //     case 0: {
                                //       tempPrescriptionUnit = splitFull.last;
                                //
                                //     }
                                //     break;
                                //     case 1: {
                                //       tempEndDate = splitFull.last;
                                //
                                //     }
                                //     break;
                                //     case 2: {
                                //       tempIntakeTime = splitFull.last;
                                //
                                //     }
                                //     break;
                                //     case 3: {
                                //       tempBrandedName = splitFull.last;
                                //
                                //     }
                                //     break;
                                //     case 4: {
                                //       tempSpecialInstruction = splitFull.last;
                                //
                                //     }
                                //     break;
                                //     case 5: {
                                //       tempGenericName = splitFull.last;
                                //     }
                                //     break;
                                //     case 6: {
                                //       tempStartDate = splitFull.last;
                                //       prescription = new Medication_Prescription(generic_name: tempGenericName, branded_name: tempBrandedName, startdate: format.parse(tempStartDate), enddate: format.parse(tempEndDate), intake_time: tempIntakeTime, special_instruction: tempSpecialInstruction, prescription_unit: tempPrescriptionUnit);
                                //       prescription_list.add(prescription);
                                //     }
                                //     break;
                                //   }
                                // }
                                //
                                // print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date
                                // symptoms_list.add(symptom);
                                // print("symptom list  " + symptoms_list.toString());
                                getMedicalPrescription();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = prescription_list.length--;
                                  final prescriptionRef = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list/' + count.toString());
                                  prescriptionRef.set({"generic_name": generic_name.toString(), "branded_name": branded_name.toString(),"dosage": dosage.toString(), "startDate": startdate.toString(), "endDate": enddate.toString(), "intake_time": quantity.toString(), "special_instruction": special_instruction, "medical_prescription_unit": prescription_unit, "prescribedBy": uid});
                                  print("Added Medication Prescription Successfully! " + uid);
                                });

                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + prescription_list.length.toString());
                              prescription_list.add(new Medication_Prescription(generic_name: generic_name, branded_name: branded_name,dosage: dosage, startdate: format.parse(startdate), enddate: format.parse(enddate), intake_time: quantity.toString(), special_instruction: special_instruction, prescription_unit: prescription_unit, prescribedBy: uid));
                              for(var i=0;i<prescription_list.length/2;i++){
                                var temp = prescription_list[i];
                                prescription_list[i] = prescription_list[prescription_list.length-1-i];
                                prescription_list[prescription_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, [prescription_list, 1]);
                            });

                          } catch(e) {
                            print("you got an error! $e");
                          }
                          // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  void getMedicalPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prescription_list.add(Medication_Prescription.fromJson(jsonString));
      });
    });
  }
}