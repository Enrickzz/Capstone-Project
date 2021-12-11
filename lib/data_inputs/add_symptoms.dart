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

import '../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_symptoms extends StatefulWidget {
  final List<Symptom> thislist;
  add_symptoms({this.thislist});
  @override
  _addSymptomsState createState() => _addSymptomsState();
}
final _formKey = GlobalKey<FormState>();
class _addSymptomsState extends State<add_symptoms> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String symptom_name = '';
  int intesity_lvl = 0;
  String symptom_felt = '';
  String symptom_date = "MM/DD/YYYY";
  DateTime symptomDate;
  bool isDateSelected= false;
  int count = 0;
  List<Symptom> symptoms_list = new List<Symptom>();
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
              'Add Symptom',
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
                hintText: "Symptom Name",
              ),
              validator: (val) => val.isEmpty ? 'Enter Symptom Name' : null,
              onChanged: (val){
                setState(() => symptom_name = val);
              },
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
                hintText: "Intensity Level (1-10)",
              ),
              validator: (val) => val.isEmpty ? 'Enter Symptom Intensity Level' : null,
              onChanged: (val){
                setState(() => intesity_lvl = int.parse(val));
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
                hintText: "General Area where symptoms is felt",
              ),
              validator: (val) => val.isEmpty ? 'Enter General are where Symptom is felt' : null,
              onChanged: (val){
                setState(() => symptom_felt = val);
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
                      if(datePick!=null && datePick!=symptomDate){
                        setState(() {
                          symptomDate=datePick;
                          isDateSelected=true;

                          // put it here
                          symptom_date = "${symptomDate.month}/${symptomDate.day}/${symptomDate.year}"; // 08/14/2019
                          AlertDialog alert = AlertDialog(
                            title: Text("My title"),
                            content: Text("This is my message."),
                            actions: [

                            ],
                          );

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
                      final readsymptom = databaseReference.child('users/' + uid + '/symptoms_list/');
                      readsymptom.once().then((DataSnapshot datasnapshot) {
                        String temp1 = datasnapshot.value.toString();
                        print("temp1 " + temp1);
                        List<String> temp = temp1.split(',');

                        Symptom symptom;


                        if(datasnapshot.value == null){
                          final symptomRef = databaseReference.child('users/' + uid + '/symptoms_list/' + 0.toString());
                          symptomRef.set({"symptom_name": symptom_name.toString(), "intensity_lvl": intesity_lvl.toString(), "symptom_felt": symptom_felt.toString(), "symptom_date": symptom_date.toString()});
                          print("Added Symptom Successfully! " + uid);
                        }
                        else{
                          int tempIntesityLvl = 0;
                          String tempSymptomName = "";
                          DateTime tempSymptomDate;
                          String tempSymptomFelt = "";
                          for(var i = 0; i < temp.length; i++){
                            String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                            List<String> splitFull = full.split(" ");
                            if(i < 4){
                              print("i value" + i.toString());
                              switch(i){
                                case 0: {
                                  print("1st switch intensity lvl " + splitFull.last);
                                  tempIntesityLvl = int.parse(splitFull.last);
                                }
                                break;
                                case 1: {
                                  print("1st switch symptom name " + splitFull.last);
                                  tempSymptomName = splitFull.last;
                                }
                                break;
                                case 2: {
                                  print("1st switch symptom date " + splitFull.last);
                                  tempSymptomDate = format.parse(splitFull.last);
                                }
                                break;
                                case 3: {
                                  print("1st switch symptom felt " + splitFull.last);
                                  tempSymptomFelt = splitFull.last;
                                  symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date: tempSymptomDate);
                                  symptoms_list.add(symptom);
                                  print("symptom  " + symptom.symptom_name + symptom.intesity_lvl.toString() + symptom.symptom_felt);

                                }
                                break;
                              }
                            }
                            else{
                              print("i value" + i.toString());
                              print("i value modulu " + (i%4).toString());
                              switch(i%4){
                                case 0: {
                                  print("2nd switch intensity lvl " + splitFull.last);
                                  tempIntesityLvl = int.parse(splitFull.last);

                                }
                                break;
                                case 1: {
                                  print("2nd switch symptom name " + splitFull.last);
                                  tempSymptomName = splitFull.last;
                                }
                                break;
                                case 2: {
                                  print("2nd switch symptom date " + splitFull.last);
                                  tempSymptomDate = format.parse(splitFull.last);

                                }
                                break;
                                case 3: {
                                  print("2nd switch symptom felt " + splitFull.last);
                                  tempSymptomFelt = splitFull.last;
                                  symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date: tempSymptomDate);
                                  symptoms_list.add(symptom);
                                  print("symptom  " + symptom.symptom_name + symptom.intesity_lvl.toString() + symptom.symptom_felt);
                                }
                                break;
                              }
                            }
                            print("symptom list length " + symptoms_list.length.toString());

                          }
                          count = symptoms_list.length;
                          print("count " + count.toString());
                          final symptomRef = databaseReference.child('users/' + uid + '/symptoms_list/' + count.toString());
                          symptomRef.set({"symptom_name": symptom_name.toString(), "intensity_lvl": intesity_lvl.toString(), "symptom_felt": symptom_felt.toString(), "symptom_date": symptom_date.toString()});
                          print("Added Symptom Successfully! " + uid);
                        }

                      });


                      Future.delayed(const Duration(milliseconds: 1000), (){
                        print("SYMPTOMS LENGTH: " + symptoms_list.length.toString());
                        symptoms_list.add(new Symptom(symptom_name: symptom_name.toString(), intesity_lvl: intesity_lvl, symptom_felt: symptom_felt,symptom_date: format.parse(symptom_date)));
                        for(var i=0;i<symptoms_list.length/2;i++){
                          var temp = symptoms_list[i];
                          symptoms_list[i] = symptoms_list[symptoms_list.length-1-i];
                          symptoms_list[symptoms_list.length-1-i] = temp;
                        }
                        print("POP HERE ==========");
                        Navigator.pop(context, symptoms_list);
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