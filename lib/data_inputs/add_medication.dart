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
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';

import 'medication.dart';
import '../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_medication extends StatefulWidget {
  final List<Medication> thislist;
  add_medication({this.thislist});
  @override
  _addMedicationState createState() => _addMedicationState();
}
final _formKey = GlobalKey<FormState>();
class _addMedicationState extends State<add_medication> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String medicine_name = '';
  String medicine_type = 'Liquid';
  double medicine_dosage = 0;
  DateTime medicineDate;
  String medicine_date = (new DateTime.now()).toString();
  String medicine_time;
  bool isDateSelected= false;
  int count = 0;
  List<Medication> medication_list = new List<Medication>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;

  var dateValue = TextEditingController();

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
                    'Add Medication Intake',
                    textAlign: TextAlign.center,
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
                      hintText: "Medicine Name",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Medicine Name' : null,
                    onChanged: (val){
                      setState(() => medicine_name = val);
                    },
                  ),
                  SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget> [
                Text(
                  "Medicine Type",
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Radio(
                          value: "Liquid",
                          groupValue: medicine_type,
                          onChanged: (value){
                            setState(() {
                              this.medicine_type = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Text("Liquid"),
                    SizedBox(width: 3),
                    Radio(
                      value: "Tablet",
                      groupValue: medicine_type,
                      onChanged: (value){
                        setState(() {
                          this.medicine_type = value;
                        });
                      },
                    ),
                    Text("Tablet"),
                    SizedBox(width: 3),
                    Radio(
                      value: "Pill",
                      groupValue: medicine_type,
                      onChanged: (value){
                        setState(() {
                          this.medicine_type = value;
                        });
                      },
                    ),
                    Text("Pill"),
                    SizedBox(width: 3),
                    Radio(
                      value: "Others",
                      groupValue: medicine_type,
                      onChanged: (value){
                        setState(() {
                          this.medicine_type = value;
                        });
                      },
                    ),
                    Text("Others"),
                    SizedBox(width: 3)
                  ],
                )

              ],
            ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.number,
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
                      hintText: "Dosage (mG / mL)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Medicine Dosage' : null,
                    onChanged: (val){
                      setState(() => medicine_dosage = double.parse(val));
                    },
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100)
                      ).then((value){
                        if(value != null && value != medicineDate){
                          setState(() {
                            medicineDate = value;
                            isDateSelected = true;
                            medicine_date = "${medicineDate.month}/${medicineDate.day}/${medicineDate.year}";
                          });
                          dateValue.text = medicine_date + "\r";
                        }
                      });

                      final initialTime = TimeOfDay(hour:12, minute: 0);
                      await showTimePicker(
                        context: context,
                        initialTime: time ?? initialTime,
                      ).then((value){
                        if(value != null && value != time){
                          setState(() {
                            time = value;
                            final hours = time.hour.toString().padLeft(2,'0');
                            final min = time.minute.toString().padLeft(2,'0');
                            medicine_time = "$hours:$min";
                            dateValue.text += "$hours:$min";
                            print("data value " + dateValue.text);
                          });
                        }
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateValue,
                        showCursor: false,
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
                          hintText: "Date and Time",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select Date and Time' : null,
                        onChanged: (val){

                          print(dateValue);
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 18.0),
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
                          Navigator.pop(context, widget.thislist);
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
                            final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list');
                            readMedication.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Medication medicine;
                              if(datasnapshot.value == null){
                                final medicationRef = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/' + 0.toString());
                                medicationRef.set({"medicine_name": medicine_name.toString(), "medicine_type": medicine_type.toString(), "medicine_dosage": medicine_dosage.toString(), "medicine_date": medicine_date.toString(), "medicine_time": medicine_time.toString()});
                                print("Added medication Successfully! " + uid);
                              }
                              else{
                                double tempMedicineDosage = 0;
                                String tempMedicineName = "";
                                DateTime tempMedicineDate;
                                DateTime tempMedicineTime;
                                String tempMedicineType = "";
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  if(i < 5){
                                    print("i value" + i.toString());
                                    switch(i){
                                      case 0: {
                                        print("1st switch i = 0 " + splitFull.last);
                                        tempMedicineType = splitFull.last;

                                      }
                                      break;
                                      case 1: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempMedicineDosage = double.parse(splitFull.last);

                                      }
                                      break;
                                      case 2: {
                                        print("1st switch i = 2 " + splitFull.last);
                                        tempMedicineDate = format.parse(splitFull.last);
                                      }
                                      break;
                                      case 3: {
                                        print("1st switch i = 3 " + splitFull.last);
                                        tempMedicineName = splitFull.last;
                                      }
                                      break;
                                      case 4: {
                                        print("1st switch i = 4 " + splitFull.last);

                                        tempMedicineTime = timeformat.parse(splitFull.last);
                                        medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: tempMedicineDate, medicine_time: tempMedicineTime);
                                        medication_list.add(medicine);
                                      }
                                      break;
                                    }
                                  }
                                  else{
                                    print("i value" + i.toString());
                                    print("i value modulu " + (i%4).toString());
                                    switch(i%5){
                                      case 0: {
                                        print("2nd switch intensity lvl " + splitFull.last);
                                        tempMedicineType = splitFull.last;

                                      }
                                      break;
                                      case 1: {
                                        print("2nd switch symptom name " + splitFull.last);
                                        tempMedicineDosage = double.parse(splitFull.last);

                                      }
                                      break;
                                      case 2: {
                                        print("2nd switch symptom date " + splitFull.last);
                                        tempMedicineDate = format.parse(splitFull.last);

                                      }
                                      break;
                                      case 3: {
                                        print("2nd switch symptom date " + splitFull.last);
                                        tempMedicineName = splitFull.last;


                                      }
                                      break;
                                      case 4: {
                                        print("2nd switch symptom felt " + splitFull.last);
                                        tempMedicineTime = timeformat.parse(splitFull.last);
                                        medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: tempMedicineDate, medicine_time: tempMedicineTime);
                                        medication_list.add(medicine);
                                      }
                                      break;
                                    }
                                  }

                                }
                                count = medication_list.length;
                                print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                // symptoms_list.add(symptom);

                                // print("symptom list  " + symptoms_list.toString());
                                final medicationRef = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/' + count.toString());
                                medicationRef.set({"medicine_name": medicine_name.toString(), "medicine_type": medicine_type.toString(), "medicine_dosage": medicine_dosage.toString(), "medicine_date": medicine_date.toString(), "medicine_time": medicine_time.toString()});
                                print("Added Symptom Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + medication_list.length.toString());
                              medication_list.add(new Medication(medicine_name: medicine_name, medicine_type: medicine_type, medicine_dosage: medicine_dosage, medicine_date: format.parse(medicine_date), medicine_time: timeformat.parse(medicine_time)));
                              for(var i=0;i<medication_list.length/2;i++){
                                var temp = medication_list[i];
                                medication_list[i] = medication_list[medication_list.length-1-i];
                                medication_list[medication_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, medication_list);
                            });
                            // print("POP HERE ========== MEDICATION");
                            // Navigator.pop(context,medication_list);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => medication()),
                            // );


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
}
