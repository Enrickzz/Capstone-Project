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
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import 'lab_results.dart';
import 'medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_lab_results extends StatefulWidget {
  @override
  _addLabResultState createState() => _addLabResultState();
}
final _formKey = GlobalKey<FormState>();
class _addLabResultState extends State<add_lab_results> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String lab_result_name = '';
  String lab_result_date = "MM/DD/YYYY";
  DateTime labResultDate;
  bool isDateSelected= false;
  int count = 0;
  List<Lab_Result> labResult_list = new List<Lab_Result>();
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
                    'Add Laboratory Result',
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
                      hintText: "Name of Lab Result",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Name of Lab Result' : null,
                    onChanged: (val){
                      setState(() => lab_result_name = val);
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
                            if(datePick!=null && datePick!=labResultDate){
                              setState(() {
                                labResultDate=datePick;
                                isDateSelected=true;

                                // put it here
                                lab_result_date = "${labResultDate.month}/${labResultDate.day}/${labResultDate.year}"; // 08/14/2019
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
                            final readLabResult = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list');
                            readLabResult.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');

                              Lab_Result labResult;


                              if(datasnapshot.value == null){
                                final labResultRef = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/' + 0.toString());
                                labResultRef.set({"labResult_name": lab_result_name.toString(), "labResult_date": lab_result_date.toString()});
                                print("Added Lab Result Successfully! " + uid);
                              }
                              else{
                                String tempLabResultName = "";
                                String tempLabResultDate;
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  if(i < 2){
                                    print("i value" + i.toString());
                                    switch(i) {
                                      case 0:
                                        {
                                          print("1st switch lab result name " + splitFull.last);
                                          tempLabResultName = splitFull.last;
                                        }
                                        break;
                                      case 1:
                                        {
                                          print("1st switch lab result date " + splitFull.last);
                                          tempLabResultDate = splitFull.last;
                                          labResult = new Lab_Result(labResult_name: tempLabResultName, labResult_date: format.parse(tempLabResultDate));
                                          labResult_list.add(labResult);
                                          print("lab result  " + labResult.labResult_name + labResult.labResult_date.toString());
                                        }
                                        break;
                                    }
                                  }
                                  else{
                                    print("i value" + i.toString());
                                    print("i value modulu " + (i%2).toString());
                                    switch(i%2){
                                      case 0: {
                                        print("2nd switch lab result name " + splitFull.last);
                                        tempLabResultName = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        print("2nd switch lab result date " + splitFull.last);
                                        tempLabResultDate = splitFull.last;
                                        labResult = new Lab_Result(labResult_name: tempLabResultName, labResult_date: format.parse(tempLabResultDate));
                                        labResult_list.add(labResult);
                                        print("lab result  " + labResult.labResult_name + labResult.labResult_date.toString());
                                      }
                                      break;

                                    }
                                  }
                                  print("lab result list length " + labResult_list.length.toString());

                                }
                                count = labResult_list.length;
                                print("count " + count.toString());
                                final labResultRef = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/' + count.toString());
                                labResultRef.set({"labResult_name": lab_result_name.toString(), "labResult_date": lab_result_date.toString()});
                                print("Added Lab Result Successfully! " + uid);
                              }

                            });


                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("LAB RESULT LENGTH: " + labResult_list.length.toString());
                              labResult_list.add(new Lab_Result(labResult_name: lab_result_name.toString(), labResult_date: format.parse(lab_result_date)));
                              for(var i=0;i<labResult_list.length/2;i++){
                                var temp = labResult_list[i];
                                labResult_list[i] = labResult_list[labResult_list.length-1-i];
                                labResult_list[labResult_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, labResult_list);
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