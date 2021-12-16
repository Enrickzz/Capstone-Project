import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/data_inputs/medication_prescription.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'medication_prescription.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_medication_prescription extends StatefulWidget {
  @override
  _addMedicationPrescriptionState createState() => _addMedicationPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addMedicationPrescriptionState extends State<add_medication_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String medicine_name = '';
  String medicine_type = 'Liquid';
  String medicine_quantity = '';


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
                    validator: (val) => val.isEmpty ? 'Enter General are where Symptom is felt' : null,
                    onChanged: (val){
                      setState(() => medicine_quantity = val);
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
                            final symptomRef = databaseReference.child('users/' + uid + '/symptoms_list');


                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => medication_prescription()),
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