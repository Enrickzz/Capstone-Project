import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure.dart';
import 'package:my_app/data_inputs/vitals/heart_rate.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../lab_results.dart';
import '../medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_heart_rate extends StatefulWidget {
  final List<Heart_Rate> thislist;
  add_heart_rate({this.thislist});
  @override
  _add_heart_rateState createState() => _add_heart_rateState();
}
final _formKey = GlobalKey<FormState>();
class _add_heart_rateState extends State<add_heart_rate> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int beats = 0;
  String isResting = 'false';
  DateTime heartRateDate;
  String heartRate_date = "MM/DD/YYYY";
  bool isDateSelected= false;
  int count = 0;
  List<Heart_Rate> heartRate_list = new List<Heart_Rate>();
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
                    'Add Heart Rate',
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
                      hintText: "Number of Beats (15 seconds x 4)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Number of Beats' : null,
                    onChanged: (val){
                      setState(() => beats = int.parse(val));
                    },
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Text(
                        "Did you just finish exercising?",
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: "Yes",
                                groupValue: isResting,
                                onChanged: (value){
                                  setState(() {
                                    this.isResting = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Text("Yes"),
                          SizedBox(width: 3),
                          Radio(
                            value: "No",
                            groupValue: isResting,
                            onChanged: (value){
                              setState(() {
                                this.isResting = value;
                              });
                            },
                          ),
                          Text("No"),
                          SizedBox(width: 3)
                        ],
                      )
                    ],
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
                            if(datePick!=null && datePick!=heartRateDate){
                              setState(() {
                                heartRateDate=datePick;
                                isDateSelected=true;

                                // put it here
                                heartRate_date = "${heartRateDate.month}/${heartRateDate.day}/${heartRateDate.year}"; // 08/14/2019
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
                            final readHeartRate = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list');
                            readHeartRate.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Heart_Rate heartRate;
                              if(datasnapshot.value == null){
                                final heartRateRef = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/' + 0.toString());

                                bool thisBool = isResting.toLowerCase() =='true';
                                heartRateRef.set({"HR_bpm": beats.toString(), "isResting": thisBool, "hr_date": heartRate_date.toString()});
                                print("Added Heart Rate Successfully! " + uid);
                              }
                              else{
                                String tempbeats = "";
                                String tempisResting;
                                String tempHeartRateDate;
                                print(temp.length);
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  if(i < 3){
                                    print("i value" + i.toString());
                                    switch(i){
                                      case 0: {
                                        print("1st switch i = 0 " + splitFull.last);
                                        tempbeats = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        print("1st switch i = 1 " + parseBool(splitFull.last).toString());
                                        tempisResting = splitFull.last;
                                      }
                                      break;
                                      case 2: {
                                        print("1st switch i = 3 " + splitFull.last);
                                        tempHeartRateDate = splitFull.last;
                                        bool thisBool = tempisResting.toLowerCase() =='true';
                                        heartRate = new Heart_Rate(bpm: int.parse(tempbeats), isResting: thisBool, hr_date: format.parse(tempHeartRateDate));
                                        heartRate_list.add(heartRate);
                                      }
                                      break;
                                    }
                                  }
                                  else{
                                    switch(i%3){
                                      case 0: {
                                        tempbeats = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        tempisResting = splitFull.last;
                                      }
                                      break;
                                      case 2: {
                                        tempHeartRateDate = splitFull.last;
                                        bool thisBool = tempisResting.toLowerCase() =='true';
                                        heartRate = new Heart_Rate(bpm: int.parse(tempbeats), isResting: thisBool, hr_date: format.parse(tempHeartRateDate));
                                        heartRate_list.add(heartRate);
                                      }
                                      break;
                                    }
                                  }

                                }
                                count = heartRate_list.length;
                                print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                // symptoms_list.add(symptom);

                                // print("symptom list  " + symptoms_list.toString());
                                final heartRateRef = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/' + count.toString());
                                heartRateRef.set({"HR_bpm": beats.toString(), "isResting": parseBool(isResting).toString(), "hr_date": heartRate_date.toString()});
                                print("Added Heart Rate Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + heartRate_list.length.toString());
                              heartRate_list.add(new Heart_Rate(bpm: beats, isResting: parseBool(isResting), hr_date: format.parse(heartRate_date)));
                              for(var i=0;i<heartRate_list.length/2;i++){
                                var temp = heartRate_list[i];
                                heartRate_list[i] = heartRate_list[heartRate_list.length-1-i];
                                heartRate_list[heartRate_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, heartRate_list);
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
bool parseBool(String temp) {
  if (temp.toLowerCase() == 'yes') {
    return false;
  } else if (temp.toLowerCase() == 'no') {
    return true;
  }
  else{
    print("error parsing bool");
  }
}