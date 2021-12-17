import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/medication_prescription.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'medication_prescription.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_medication_prescription extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  add_medication_prescription({this.thislist});
  @override
  _addMedicationPrescriptionState createState() => _addMedicationPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addMedicationPrescriptionState extends State<add_medication_prescription> {
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
  String intake_time = "";
  String special_instruction = "";
  int count = 0;
  List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();

  DateTimeRange dateRange;
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

    setState(() => dateRange = newDateRange);
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
                    'Add Medication Prescription',
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
                      hintText: "Generic Name",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Generic Name' : null,
                    onChanged: (val){
                      setState(() => generic_name = val);
                    },
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
                      hintText: "Medicine Brand",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Branded Name' : null,
                    onChanged: (val){
                      setState(() => branded_name = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => pickDateRange(context),

                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: startDate,
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
                          hintText: "Start Date",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select Start Date' : null,
                        onChanged: (val){

                          print(startDate);
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => pickDateRange(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: endDate,
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
                          hintText: "End Date",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select End Date' : null,
                        onChanged: (val){

                          print(endDate);
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  // SizedBox(height: 8.0),
                  // GestureDetector(
                  //   onTap: ()async{
                  //     await showDatePicker(
                  //         context: context,
                  //         initialDate: new DateTime.now(),
                  //         firstDate: new DateTime(1900),
                  //         lastDate: new DateTime(2100)
                  //     ).then((value){
                  //       if(value != null && value != prescriptionDate){
                  //         setState(() {
                  //           prescriptionDate = value;
                  //           isDateSelected = true;
                  //           startdate = "${prescriptionDate.month}/${prescriptionDate.day}/${prescriptionDate.year}";
                  //         });
                  //         startDate.text = startdate + "\r";
                  //       }
                  //     });
                  //   },
                  //   child: AbsorbPointer(
                  //     child: TextFormField(
                  //       controller: startDate,
                  //       showCursor: false,
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //           borderSide: BorderSide(
                  //             width:0,
                  //             style: BorderStyle.none,
                  //           ),
                  //         ),
                  //         filled: true,
                  //         fillColor: Color(0xFFF2F3F5),
                  //         hintStyle: TextStyle(
                  //             color: Color(0xFF666666),
                  //             fontFamily: defaultFontFamily,
                  //             fontSize: defaultFontSize),
                  //         hintText: "Start Date",
                  //         prefixIcon: Icon(
                  //           Icons.calendar_today,
                  //           color: Color(0xFF666666),
                  //           size: defaultIconSize,
                  //         ),
                  //       ),
                  //       validator: (val) => val.isEmpty ? 'Select Start Date' : null,
                  //       onChanged: (val){
                  //
                  //         print(startDate);
                  //         setState((){
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),


                  // SizedBox(height: 8.0),
                  // GestureDetector(
                  //   onTap: ()async{
                  //     await showDatePicker(
                  //         context: context,
                  //         initialDate: new DateTime.now(),
                  //         firstDate: new DateTime(1900),
                  //         lastDate: new DateTime(2100)
                  //     ).then((value){
                  //       if(value != null && value != prescriptionDate){
                  //         setState(() {
                  //           prescriptionDate = value;
                  //           isDateSelected = true;
                  //           enddate = "${prescriptionDate.month}/${prescriptionDate.day}/${prescriptionDate.year}";
                  //         });
                  //         endDate.text = enddate + "\r";
                  //       }
                  //     });
                  //   },
                  //   child: AbsorbPointer(
                  //     child: TextFormField(
                  //       controller: endDate,
                  //       showCursor: false,
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //           borderSide: BorderSide(
                  //             width:0,
                  //             style: BorderStyle.none,
                  //           ),
                  //         ),
                  //         filled: true,
                  //         fillColor: Color(0xFFF2F3F5),
                  //         hintStyle: TextStyle(
                  //             color: Color(0xFF666666),
                  //             fontFamily: defaultFontFamily,
                  //             fontSize: defaultFontSize),
                  //         hintText: "End Date",
                  //         prefixIcon: Icon(
                  //           Icons.calendar_today,
                  //           color: Color(0xFF666666),
                  //           size: defaultIconSize,
                  //         ),
                  //       ),
                  //       validator: (val) => val.isEmpty ? 'Select End Date' : null,
                  //       onChanged: (val){
                  //
                  //         print(endDate);
                  //         setState((){
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
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
                      hintText: "Intake Time",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Intake Time' : null,
                    onChanged: (val){
                      setState(() => intake_time = val);
                    },
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
                      hintText: "Special Instructions",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Special Instructions' : null,
                    onChanged: (val){
                      setState(() => special_instruction = val);
                    },
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
                                prescriptionRef.set({"generic_name": generic_name.toString(), "branded_name": branded_name.toString(), "startDate": startdate.toString(), "endDate": enddate.toString(), "intake_time": intake_time.toString(), "special_instruction": special_instruction});
                                print("Added Medication Prescription Successfully! " + uid);
                              }
                              else{
                                String tempGenericName = "";
                                String tempBrandedName = "";
                                String tempIntakeTime = "";
                                String tempSpecialInstruction = "";
                                String tempStartDate = "";
                                String tempEndDate = "";
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  switch(i%6){
                                    case 0: {
                                      tempEndDate = splitFull.last;
                                    }
                                    break;
                                    case 1: {
                                      tempIntakeTime = splitFull.last;
                                    }
                                    break;
                                    case 2: {
                                      tempBrandedName = splitFull.last;
                                    }
                                    break;
                                    case 3: {
                                      tempSpecialInstruction = splitFull.last;
                                    }
                                    break;
                                    case 4: {
                                      tempGenericName = splitFull.last;
                                    }
                                    break;
                                    case 5: {
                                      tempStartDate = splitFull.last;
                                      prescription = new Medication_Prescription(generic_name: tempGenericName, branded_name: tempBrandedName, startdate: format.parse(tempStartDate), enddate: format.parse(tempEndDate), intake_time: tempIntakeTime, special_instruction: tempSpecialInstruction);
                                      prescription_list.add(prescription);
                                    }
                                    break;
                                  }
                                }
                                count = prescription_list.length;
                                print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                // symptoms_list.add(symptom);

                                // print("symptom list  " + symptoms_list.toString());
                                final prescriptionRef = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list/' + count.toString());
                                prescriptionRef.set({"generic_name": generic_name.toString(), "branded_name": branded_name.toString(), "startDate": startdate.toString(), "endDate": enddate.toString(), "intake_time": intake_time.toString(), "special_instruction": special_instruction});
                                print("Added Medication Prescription Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + prescription_list.length.toString());
                              prescription_list.add(new Medication_Prescription(generic_name: generic_name, branded_name: branded_name, startdate: format.parse(startdate), enddate: format.parse(enddate), intake_time: intake_time, special_instruction: special_instruction));
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
}