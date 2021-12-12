import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_glucose.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../lab_results.dart';
import '../medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_blood_glucose extends StatefulWidget {
  @override
  _add_blood_glucoseState createState() => _add_blood_glucoseState();
}
final _formKey = GlobalKey<FormState>();
class _add_blood_glucoseState extends State<add_blood_glucose> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double glucose = 0;
  String status = '';
  DateTime glucoseDate;
  String glucose_date = "MM/DD/YYYY";
  bool isDateSelected= false;
  int count = 0;
  List<Blood_Glucose> glucose_list = new List<Blood_Glucose>();
  DateFormat format = new DateFormat("MM/dd/yyyy");

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
                    'Add Blood Glucose Level',
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
                      hintText: "Blood Glucose Level (mg/dL)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Blood Glucose Level' : null,
                    onChanged: (val){
                      setState(() => glucose = double.parse(val));
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
                      hintText: "Status when you took your blood glucose level",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter status when you took your blood glucose level' : null,
                    onChanged: (val){
                      setState(() => status = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                          child: new Icon(Icons.calendar_today),
                          onTap: ()async{
                            final datePick= await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime(1900),
                                lastDate: new DateTime(2100)
                            );
                            if(datePick!=null && datePick!=glucoseDate){
                              setState(() {
                                glucoseDate=datePick;
                                isDateSelected=true;

                                // put it here
                                glucose_date = "${glucoseDate.month}/${glucoseDate.day}/${glucoseDate.year}"; // 08/14/2019
                                // AlertDialog alert = AlertDialog(
                                //   title: Text("My title"),
                                //   content: Text("This is my message."),
                                //   actions: [
                                //
                                //   ],
                                // );

                              });
                            }
                          }
                      ), Container(
                          child: Text(
                              " MM/DD/YYYY ",
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize,
                                fontStyle: FontStyle.normal,
                              )
                          )
                      ),
                    ],
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
                            final readGlucose = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list');
                            readGlucose.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Blood_Glucose bloodGlucose;
                              if(datasnapshot.value == null){
                                final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + 0.toString());
                                glucoseRef.set({"glucose": glucose.toString(), "status": status.toString(), "bloodGlucose_date": glucose_date.toString()});
                                print("Added Blood Glucose Successfully! " + uid);
                              }
                              else{
                                String tempGlucose = "";
                                String tempStatus = "";
                                String tempGlucoseDate;
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  if(i < 3){
                                    print("i value" + i.toString());
                                    switch(i){
                                      case 0: {
                                        print("1st switch i = 0 " + splitFull.last);
                                        tempGlucose = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        print("1st switch i = 2 " + splitFull.last);
                                        tempGlucoseDate = splitFull.last;

                                      }
                                      break;
                                      case 2: {
                                        print("1st switch i = 3 " + splitFull.last);
                                        tempStatus = splitFull.last;
                                        bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), status: tempStatus, bloodGlucose_date: format.parse(tempGlucoseDate));
                                        glucose_list.add(bloodGlucose);
                                      }
                                      break;
                                    }
                                  }
                                  else{
                                    switch(i%3){
                                      case 0: {
                                        tempGlucose = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        tempGlucoseDate = splitFull.last;
                                      }
                                      break;
                                      case 2: {

                                        tempStatus = splitFull.last;
                                        bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), status: tempStatus, bloodGlucose_date: format.parse(tempGlucoseDate));
                                        glucose_list.add(bloodGlucose);
                                      }
                                      break;
                                    }
                                  }

                                }
                                count = glucose_list.length;
                                print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                // symptoms_list.add(symptom);

                                // print("symptom list  " + symptoms_list.toString());
                                final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + count.toString());
                                glucoseRef.set({"glucose": glucose.toString(), "status": status.toString(), "bloodGlucose_date": glucose_date.toString()});
                                print("Added Blood Glucose Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              glucose_list.add(new Blood_Glucose(glucose: glucose, status: status, bloodGlucose_date: format.parse(glucose_date)));
                              for(var i=0;i<glucose_list.length/2;i++){
                                var temp = glucose_list[i];
                                glucose_list[i] = glucose_list[glucose_list.length-1-i];
                                glucose_list[glucose_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, glucose_list);
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => blood_glucose()),
                            );

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