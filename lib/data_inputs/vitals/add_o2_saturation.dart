import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../lab_results.dart';
import '../medication.dart';
import 'o2_saturation.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_o2_saturation extends StatefulWidget {
  @override
  _add_o2_saturationState createState() => _add_o2_saturationState();
}
final _formKey = GlobalKey<FormState>();
class _add_o2_saturationState extends State<add_o2_saturation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double spo2 = 0;

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
                      setState(() => spo2 = double.parse(val));
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

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => o2_saturation()),
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