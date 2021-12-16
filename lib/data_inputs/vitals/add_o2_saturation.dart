import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../lab_results.dart';
import '../medication.dart';
import 'o2_saturation.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_o2_saturation extends StatefulWidget {
  final List<Oxygen_Saturation> o2list;
  add_o2_saturation({this.o2list});
  @override
  _add_o2_saturationState createState() => _add_o2_saturationState();
}
final _formKey = GlobalKey<FormState>();
class _add_o2_saturationState extends State<add_o2_saturation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int spo2 = 0;
  bool isDateSelected= false;
  DateTime oxygenDate;
  String oxygen_date = (new DateTime.now()).toString();
  String oxygen_time;
  int count = 0;
  List<Oxygen_Saturation> oxygen_list = new List<Oxygen_Saturation>();
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
                    'Add Oxygen Saturation',
                    textAlign: TextAlign.center,
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
                      hintText: "Oxygen Saturation (%SpO2)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Oxygen Saturation (%SpO2)' : null,
                    onChanged: (val){
                      setState(() => spo2 = int.parse(val));
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
                        if(value != null && value != oxygenDate){
                          setState(() {
                            oxygenDate = value;
                            isDateSelected = true;
                            oxygen_date = "${oxygenDate.month}/${oxygenDate.day}/${oxygenDate.year}";
                          });
                          dateValue.text = oxygen_date + "\r";
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
                            oxygen_time = "$hours:$min";
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
                            final readOxygen = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list');
                            readOxygen.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Oxygen_Saturation oxygen;
                              if(datasnapshot.value == null){
                                final oxygenRef = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/' + 0.toString());
                                oxygenRef.set({"oxygen_saturation": spo2.toString(), "os_date": oxygen_date.toString(), "os_time": oxygen_time.toString()});
                                print("Added Oxygen Saturation Successfully! " + uid);
                              }
                              else{
                                String tempOxygen = "";
                                String tempOxygenDate = "";
                                String tempOxygenTime = "";
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  switch(i%3){
                                    case 0: {
                                      tempOxygen = splitFull.last;
                                    }
                                    break;
                                    case 1: {
                                      tempOxygenDate = splitFull.last;
                                    }
                                    break;
                                    case 2: {
                                      tempOxygenTime = splitFull.last;
                                      oxygen = new Oxygen_Saturation(oxygen_saturation: int.parse(tempOxygen), os_date: format.parse(tempOxygenDate), os_time: timeformat.parse(tempOxygenTime));
                                      oxygen_list.add(oxygen);
                                    }
                                    break;
                                  }
                                }
                                count = oxygen_list.length;
                                print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                // symptoms_list.add(symptom);

                                // print("symptom list  " + symptoms_list.toString());
                                final oxygenRef = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/' + count.toString());
                                oxygenRef.set({"oxygen_saturation": spo2.toString(), "os_date": oxygen_date.toString(), "os_time": oxygen_time.toString()});
                                print("Added Oxygen Saturation Successfully! " + uid);
                              }

                            });

                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + oxygen_list.length.toString());
                              oxygen_list.add(new Oxygen_Saturation(oxygen_saturation: spo2, os_date: format.parse(oxygen_date), os_time: timeformat.parse(oxygen_time)));
                              for(var i=0;i<oxygen_list.length/2;i++){
                                var temp = oxygen_list[i];
                                oxygen_list[i] = oxygen_list[oxygen_list.length-1-i];
                                oxygen_list[oxygen_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, oxygen_list);
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