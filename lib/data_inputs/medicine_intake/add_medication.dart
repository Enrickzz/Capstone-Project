import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/users.dart';
class add_medication extends StatefulWidget {
  final List<Medication> thislist;
  final String userUID;
  add_medication({this.thislist, this.instance, this.userUID});
  final String instance;
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
  double hint_dosage = 0;
  String hint_unit = "";
  String medicine_unit = "mL";
  DateTime medicineDate;
  String medicine_date = (new DateTime.now()).toString();
  String medicine_time;
  bool isDateSelected= false;
  int count = 1;
  int picked = 0;
  List<Medication> medication_list = new List<Medication>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  List<Medication_Prescription> medical_list = [];
  List<Supplement_Prescription> supplement_list = [];
  List<listMeds> medical_name = [];
  List <bool> isSelected = [false];


  var dateValue = TextEditingController();
  String valueChooseMedicineSupplement;
  List<listMeds> listMedicineSupplement =[];
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (widget.userUID != null) {
      uid = widget.userUID;
    } else {
      final User user = auth.currentUser;
      uid = user.uid;
    }
    getSupplementName();
    getPrescriptionGName();
    getPrescriptionBName();

    Future.delayed(const Duration(milliseconds: 1000), (){
      listMedicineSupplement = medical_name;
      print("list medicine supplement length " + listMedicineSupplement.length.toString());
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
    print(listMedicineSupplement);
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
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
                      hintText: "Medicine/Supplement: ",
                    ),
                    isExpanded: true,
                    value: valueChooseMedicineSupplement,
                    onChanged: (newValue){
                      setState(() {
                        valueChooseMedicineSupplement = newValue;
                        print("NEW VALUE " + newValue);
                        // picked = listMedicineSupplement.indexOf(newValue);
                        for(int i = 0; i < medical_name.length; i++){
                          if(medical_name[i].name == newValue){
                            hint_unit = medical_name[i].dosage + " " + medical_name[i].unit;
                            medicine_dosage = double.parse(medical_name[i].dosage);
                            medicine_unit = medical_name[i].unit.toString();
                          }
                          else if (medical_name[i].name == newValue){
                            hint_unit = medical_name[i].dosage + " " + medical_name[i].unit;
                            medicine_dosage = double.parse(medical_name[i].dosage);

                            medicine_unit = medical_name[i].unit.toString();
                          }
                        }
                        for(int i = 0; i < medical_name.length; i++){
                          if(medical_name[i].name == newValue){
                            hint_unit = medical_name[i].dosage + " " + medical_name[i].unit;
                            medicine_dosage = double.parse(medical_name[i].dosage);
                            medicine_unit = medical_name[i].unit.toString();
                          }
                        }
                      });
                    },
                    items: listMedicineSupplement.map((valueItem){
                      return DropdownMenuItem(
                          value: valueItem.name,
                          child: Text(valueItem.name)
                      );
                    },
                    ).toList(),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                          child:TextFormField(
                            enabled: false,
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
                              hintText: hint_unit,
                            ),
                            validator: (val) => val.isEmpty ? 'Enter Medicine Dosage' : null,
                            onChanged: (val){
                              setState(() => medicine_dosage = double.parse(val));
                            },
                          ),
                      ),
                      SizedBox(width: 8.0),
                      ToggleButtons(
                        isSelected: isSelected,
                        borderRadius: BorderRadius.circular(10),
                        highlightColor: Colors.blue,
                        children: <Widget> [
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(medicine_unit, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                          ),

                        ],
                        // onPressed:(){
                        //
                        // },
                      ),
                    ],
                  ),

                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime.now().subtract(Duration(days: 30)),
                        lastDate: new DateTime.now(),
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
                        initialTime: TimeOfDay(
                            hour: TimeOfDay.now().hour,
                            minute: (TimeOfDay.now().minute - TimeOfDay.now().minute % 10 + 10)
                                .toInt()),
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
                        keyboardType: TextInputType.number,
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
                            final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list');
                            readMedication.once().then((DataSnapshot datasnapshot) {
                              if(datasnapshot.value == null){
                                final medicationRef = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/' + count.toString());
                                medicationRef.set({"medicine_name": valueChooseMedicineSupplement.toString(), "medicine_type": medicine_type.toString(),"medicine_unit": medicine_unit.toString(),  "medicine_dosage": medicine_dosage.toString(), "medicine_date": medicine_date.toString(), "medicine_time": medicine_time.toString()});
                                print("Added medication Successfully! " + uid);
                              }
                              else{
                                getMedication();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = medication_list.length--;
                                  final medicationRef = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/' + count.toString());
                                  medicationRef.set({"medicine_name": valueChooseMedicineSupplement.toString(), "medicine_type": medicine_type.toString(),"medicine_unit": medicine_unit.toString(), "medicine_dosage": medicine_dosage.toString(), "medicine_date": medicine_date.toString(), "medicine_time": medicine_time.toString()});
                                  print("Added Symptom Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + medication_list.length.toString());
                              medication_list.add(new Medication(medicine_name: valueChooseMedicineSupplement, medicine_type: medicine_type
                                  , medicine_unit: medicine_unit, medicine_dosage: medicine_dosage
                                  , medicine_date: format.parse(medicine_date), medicine_time: timeformat.parse(medicine_time)));

                              for(var i=0;i<medication_list.length/2;i++){
                                var temp = medication_list[i];
                                medication_list[i] = medication_list[medication_list.length-1-i];
                                medication_list[medication_list.length-1-i] = temp;
                              }
                              for(var i = 0; i < medication_list.length; i++){
                                print(medication_list[i].medicine_name);
                              }
                              print("POP HERE ==========");
                              Medication newMed = new Medication(medicine_name: valueChooseMedicineSupplement, medicine_type: medicine_type
                                  , medicine_unit: medicine_unit, medicine_dosage: medicine_dosage
                                  , medicine_date: format.parse(medicine_date), medicine_time: timeformat.parse(medicine_time));
                              Navigator.pop(context, newMed);
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
  void getMedication() {
    final readmedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/');
    readmedication.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        medication_list.add(Medication.fromJson(jsonString));
      });
    });
  }
  void getPrescriptionGName() {
    final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      int gcount = 0;
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        medical_list.add(Medication_Prescription.fromJson(jsonString));
        //medical_name.add(medical_list[gcount].generic_name);
        //medical_name.add(new listMeds(medical_list[gcount].generic_name, medical_list[gcount].dosage.toString(), medical_list[gcount].prescription_unit));
        gcount++;
      });
    });
  }
  void getPrescriptionBName() {
    final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      int bcount = 0;
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          medical_list.add(Medication_Prescription.fromJson(jsonString));
          // medical_name.add(medical_list[bcount].branded_name);
          medical_name.add(new listMeds(medical_list[bcount].generic_name, medical_list[bcount].dosage.toString(), medical_list[bcount].prescription_unit));

          bcount++;
        });
      }

    });
  }
  void getSupplementName() {
    final readsupplement = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/');
    readsupplement.once().then((DataSnapshot snapshot){
      int suppcount = 0;
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          supplement_list.add(Supplement_Prescription.fromJson(jsonString));
          // medical_name.add(supplement_list[suppcount].supplement_name);
          medical_name.add(new listMeds(supplement_list[suppcount].supplement_name, supplement_list[suppcount].dosage.toString(), supplement_list[suppcount].prescription_unit));

          suppcount++;
        });
      }
    });
  }

}
class listMeds{
  String name;
  String dosage;
  String unit;

  listMeds(this.name, this.dosage, this.unit);
}
