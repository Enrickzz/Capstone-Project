import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/symptoms.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_symptoms extends StatefulWidget {
  @override
  _addSymptomsState createState() => _addSymptomsState();
}

class _addSymptomsState extends State<add_symptoms> {


  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
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
                hintText: "Intensity Level",
              ),
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
                      // if(datePick!=null && datePick!=birthDate){
                      //   setState(() {
                      //     // birthDate=datePick;
                      //     // isDateSelected=true;
                      //     //
                      //     // // put it here
                      //     // birthDateInString = "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
                      //     // AlertDialog alert = AlertDialog(
                      //     //   title: Text("My title"),
                      //     //   content: Text("This is my message."),
                      //     //   actions: [
                      //     //
                      //     //   ],
                      //     // );
                      //
                      //   });
                      // }
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
                  onPressed:() {
                    Navigator.pop(context);
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
